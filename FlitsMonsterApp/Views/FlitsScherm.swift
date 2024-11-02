import SwiftUI
import SwiftData

struct FlitsScherm: View {
    @Environment(\.modelContext) private var context
    let lijst: Lijst

    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }

        var isDragging: Bool {
            switch self {
            case .dragging:
                return true
            case .pressing, .inactive:
                return false
            }
        }

        var isPressing: Bool {
            switch self {
            case .pressing, .dragging:
                return true
            case .inactive:
                return false
            }
        }
    }

    @AppStorage("flitstijd") private var flitstijd: Int = 60
    @AppStorage("newCardTime") private var newCardTime: Double = 10
    @AppStorage("showProgressBar") private var showProgressBar = true
    @State private var countdown: Int = 0
    @State private var sessionTimer: Timer?
    @State private var noSwipeTimer: Timer?

    @State private var cardViews: [CardView] = []
    @State private var currentIndex = 0
    @State private var removalTransition = AnyTransition.move(edge: .trailing)
    @GestureState private var dragState = DragState.inactive
    private let dragThreshold: CGFloat = 80.0

    @State private var displayStartTime: Date?
    @State private var isSessionActive = true {
        didSet {
            if !isSessionActive {
                lijst.verhoogVoortgang(in: context)
            }
        }
    }
    @State private var knownCount = 0
    @State private var morePracticeWords: [Woord] = []

    var body: some View {
        VStack {
            if isSessionActive {
                if showProgressBar {
                    CircularProgressBar(progress: Double(countdown) / Double(flitstijd), knownCount: knownCount)
                        .padding(.top, 20)
                }

                flashCardDeckView
            } else {
                SessionSummaryView(
                    knownCount: knownCount,
                    morePracticeWords: morePracticeWords,
                    restartSession: resetSession
                )
            }
        }
        .onAppear { resetSession() }
        .onDisappear { stopTimers() }
    }

    private var flashCardDeckView: some View {
        VStack {
            Spacer()

            ZStack {
                ForEach(cardViews) { cardView in
                    cardView
                        .zIndex(self.isTopCard(cardView: cardView) ? 1 : 0)
                        .overlay {
                            ZStack {
                                if self.dragState.translation.width < -self.dragThreshold && self.isTopCard(cardView: cardView) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .foregroundColor(.blue.opacity(0.2))
                                        .font(.system(size: 200))
                                }

                                if self.dragState.translation.width > self.dragThreshold && self.isTopCard(cardView: cardView) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green.opacity(0.2))
                                        .font(.system(size: 200))
                                }
                            }
                        }
                        .offset(x: self.isTopCard(cardView: cardView) ? self.dragState.translation.width : 0)
                        .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.95 : 1.0)
                        .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 15) : 0))
                        .animation(.interpolatingSpring(stiffness: 100, damping: 50), value: self.dragState.translation)
                        .transition(self.removalTransition)
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture())
                            .updating(self.$dragState) { value, state, _ in
                                switch value {
                                case .first(true):
                                    state = .pressing
                                case .second(true, let drag):
                                    state = .dragging(translation: drag?.translation ?? .zero)
                                default:
                                    break
                                }
                            }
                            .onChanged { value in
                                guard case .second(true, let drag?) = value else { return }
                                
                                if drag.translation.width < -self.dragThreshold {
                                    self.removalTransition = .move(edge: .leading)
                                } else if drag.translation.width > self.dragThreshold {
                                    self.removalTransition = .move(edge: .trailing)
                                }
                                resetNoSwipeTimer()
                            }
                            .onEnded { value in
                                guard case .second(true, let drag?) = value else { return }

                                if abs(drag.translation.width) > self.dragThreshold {
                                    if let startTime = displayStartTime {
                                        let swipeDirection: SwipeDirection = drag.translation.width < 0 ? .left : .right
                                        let newStatus = WoordHelper.determinePracticeStatus(startTime: startTime, swipeDirection: swipeDirection)

                                        if let topWord = cardViews.first?.woord {
                                            WoordHelper.updatePracticeStatus(for: topWord, with: newStatus)
                                            if newStatus == .known || newStatus == .slow {
                                                knownCount += 1
                                            } else if newStatus == .morePractice {
                                                morePracticeWords.append(topWord)
                                            }
                                        }
                                    }
                                    moveCard()
                                }
                            }
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer()
        }
        .onAppear {
            displayStartTime = WoordHelper.startTrackingTime()
        }
    }

    private func setupCardViews() {
        let activeWords = lijst.woorden.filter { $0.isActive }
        cardViews = activeWords.prefix(2).map { CardView(woord: $0) }
        currentIndex = 2
    }

    private func isTopCard(cardView: CardView) -> Bool {
        cardViews.first?.id == cardView.id
    }

    private func moveCard(automatic: Bool = false) {
        guard !cardViews.isEmpty else {
            isSessionActive = false
            return
        }

        if let topWord = cardViews.first?.woord {
            let status: Woord.PracticeState = automatic ? .morePractice : .known
            WoordHelper.updatePracticeStatus(for: topWord, with: status)

            if status == .morePractice {
                morePracticeWords.append(topWord)
            }
        }

        // Use different animations for swipe and no-swipe
        if automatic {
            withAnimation(.bouncy) { // Slower, subtle animation for no-swipe
                removalTransition = .move(edge:.top) // Move to bottom on no-swipe
                cardViews.removeFirst()
            }
        } else {
            withAnimation(.interpolatingSpring(stiffness: 200, damping: 20)) { // Dynamic spring for swipe
                removalTransition = .move(edge: .trailing) // Move to side on swipe
                cardViews.removeFirst()
            }
        }

        // Delay addition of the next card to avoid snap-back effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let activeWords = lijst.woorden.filter { $0.isActive }
            
            if currentIndex < activeWords.count {
                let woord = activeWords[currentIndex]
                let newCardView = CardView(woord: woord)
                cardViews.append(newCardView)
                currentIndex += 1
            } else {
                isSessionActive = false
            }

            displayStartTime = WoordHelper.startTrackingTime()
            resetNoSwipeTimer()
        }
    }

    private func resetSession() {
        stopTimers()
        isSessionActive = true
        knownCount = 0
        morePracticeWords = []
        setupCardViews()
        startTimer()
        resetNoSwipeTimer()
    }
    
    private func startTimer() {
        countdown = flitstijd
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
                isSessionActive = false
            }
        }
    }

    private func resetNoSwipeTimer() {
        noSwipeTimer?.invalidate()
        noSwipeTimer = Timer.scheduledTimer(withTimeInterval: newCardTime, repeats: false) { _ in
            moveCard(automatic: true)
        }
    }

    private func stopTimers() {
        sessionTimer?.invalidate()
        noSwipeTimer?.invalidate()
        sessionTimer = nil
        noSwipeTimer = nil
    }
}

#Preview {
    FlitsScherm(lijst: Lijst.lijstM4)
}
