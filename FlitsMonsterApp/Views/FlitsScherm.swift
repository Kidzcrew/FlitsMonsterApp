import SwiftUI
import SwiftData

struct FlitsScherm: View {
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
    @AppStorage("newCardTime") private var newCardTime: Double = 10 // Default time for showing the next card
    @State private var countdown: Int = 0
    @State private var sessionTimer: Timer?
    @State private var noSwipeTimer: Timer? // Timer for inactivity detection

    @State private var cardViews: [CardView] = []
    @State private var currentIndex = 0
    @State private var removalTransition = AnyTransition.trailingBottom
    @GestureState private var dragState = DragState.inactive
    private let dragThreshold: CGFloat = 80.0

    @State private var displayStartTime: Date?
    @State private var isSessionActive = true
    @State private var knownCount = 0
    @State private var morePracticeWords: [Woord] = []

    var body: some View {
        VStack {
            if isSessionActive {
                flashCardDeckView
            } else {
                SessionSummaryView(
                    knownCount: knownCount,
                    morePracticeWords: morePracticeWords,
                    restartSession: resetSession
                )
            }
        }
        .onAppear {
            resetSession()
        }
        .onDisappear {
            stopTimers()
        }
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
                        .offset(x: self.isTopCard(cardView: cardView) ? self.dragState.translation.width : 0, y: self.isTopCard(cardView: cardView) ? self.dragState.translation.height : 0)
                        .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.95 : 1.0)
                        .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 10) : 0))
                        .animation(.interpolatingSpring(stiffness: 180, damping: 100), value: self.dragState.translation)
                        .transition(self.removalTransition)
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture())
                            .updating(self.$dragState, body: { (value, state, transaction) in
                                switch value {
                                case .first(true):
                                    state = .pressing
                                case .second(true, let drag):
                                    state = .dragging(translation: drag?.translation ?? .zero)
                                default:
                                    break
                                }
                            })
                            .onChanged({ (value) in
                                guard case .second(true, let drag?) = value else {
                                    return
                                }

                                if drag.translation.width < -self.dragThreshold {
                                    self.removalTransition = .leadingBottom
                                }

                                if drag.translation.width > self.dragThreshold {
                                    self.removalTransition = .trailingBottom
                                }
                                resetNoSwipeTimer() // Reset the inactivity timer on swipe
                            })
                            .onEnded({ (value) in
                                guard case .second(true, let drag?) = value else {
                                    return
                                }

                                if drag.translation.width < -self.dragThreshold || drag.translation.width > self.dragThreshold {
                                    if let startTime = displayStartTime {
                                        let swipeDirection: SwipeDirection = drag.translation.width < 0 ? .left : .right
                                        let newStatus = WoordHelper.determinePracticeStatus(startTime: startTime, swipeDirection: swipeDirection)

                                        if let topWord = cardViews.first?.woord {
                                            WoordHelper.updatePracticeStatus(for: topWord, with: newStatus)
                                            print("Updated status for \(topWord.naam): \(newStatus.rawValue)")

                                            if newStatus == .known || newStatus == .slow {
                                                knownCount += 1
                                            } else if newStatus == .morePractice {
                                                morePracticeWords.append(topWord)
                                            }
                                        }
                                    }
                                    moveCard() // Move to the next card
                                }
                            })
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
        
        cardViews = []
        for index in 0..<min(activeWords.count, 2) {
            let woord = activeWords[index]
            cardViews.append(CardView(woord: woord))
        }
        currentIndex = 2
    }

    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }
        return index == 0
    }

    private func moveCard() {
        // Ensure there is a card to remove; if not, end the session
        guard !cardViews.isEmpty else {
            isSessionActive = false
            return
        }

        // Check if the top card should be marked as MorePractice (when auto-replaced)
        if let topWord = cardViews.first?.woord {
            WoordHelper.updatePracticeStatus(for: topWord, with: .morePractice)
            print("Automatically updated status for \(topWord.naam): MorePractice")
            
            // Track the word for more practice if not already in the list
            if !morePracticeWords.contains(where: { $0.id == topWord.id }) {
                morePracticeWords.append(topWord)
            }
        }

        // Animate the removal of the top card and the addition of a new card
        withAnimation(.easeInOut(duration: 0.3)) {
            cardViews.removeFirst()

            let activeWords = lijst.woorden.filter { $0.isActive }
            
            if currentIndex < activeWords.count {
                let woord = activeWords[currentIndex]
                let newCardView = CardView(woord: woord)
                cardViews.append(newCardView)
                currentIndex += 1
            } else {
                isSessionActive = false  // End session when there are no more active cards
            }
        }

        displayStartTime = WoordHelper.startTrackingTime()
        resetNoSwipeTimer()  // Reset the timer for showing the next card automatically
    }

    private func resetSession() {
        stopTimers()
        isSessionActive = true
        knownCount = 0
        morePracticeWords = []
        setupCardViews()
        startTimer()
        resetNoSwipeTimer() // Start inactivity timer at the beginning of the session
    }
    
    private func startTimer() {
        countdown = flitstijd
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
                isSessionActive = false  // End session when time is up
            }
        }
    }

    private func resetNoSwipeTimer() {
        noSwipeTimer?.invalidate()
        noSwipeTimer = Timer.scheduledTimer(withTimeInterval: newCardTime, repeats: false) { _ in
            moveCard() // Move to the next card if no swipe detected within the interval
        }
    }

    private func stopTimers() {
        sessionTimer?.invalidate()
        noSwipeTimer?.invalidate()
        sessionTimer = nil
        noSwipeTimer = nil
    }
}

// AnyTransition extensions
extension AnyTransition {
    static var trailingBottom: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .identity,
            removal: AnyTransition.move(edge: .trailing).combined(with: .move(edge: .bottom))
        )
    }

    static var leadingBottom: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .identity,
            removal: AnyTransition.move(edge: .leading).combined(with: .move(edge: .bottom))
        )
    }
}

#Preview {
    FlitsScherm(lijst: Lijst.lijstM4)
}
