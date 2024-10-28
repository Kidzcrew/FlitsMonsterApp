import Foundation

// Enum for swipe direction
enum SwipeDirection {
    case left
    case right
}

struct WoordHelper {
    // Start time tracking when a word is displayed
    static func startTrackingTime() -> Date {
        return Date()
    }

    // Determine the practice status based on swipe direction and time elapsed
    static func determinePracticeStatus(startTime: Date, swipeDirection: SwipeDirection) -> Woord.PracticeState {
        let elapsedTime = Date().timeIntervalSince(startTime)
        
        switch swipeDirection {
        case .right:
            return elapsedTime <= 2 ? .known : .slow
        case .left:
            return .morePractice
        }
    }

    // Update the practice status fields in the correct order, maintaining the latest 5 statuses
    static func updatePracticeStatus(for woord: Woord, with newStatus: Woord.PracticeState) {
        // Check and update each practice field in order
        if Woord.PracticeState.fromString(woord.practice1) == .new {
            woord.practice1 = newStatus.rawValue
        } else if Woord.PracticeState.fromString(woord.practice2) == .new {
            woord.practice2 = newStatus.rawValue
        } else if Woord.PracticeState.fromString(woord.practice3) == .new {
            woord.practice3 = newStatus.rawValue
        } else if Woord.PracticeState.fromString(woord.practice4) == .new {
            woord.practice4 = newStatus.rawValue
        } else if Woord.PracticeState.fromString(woord.practice5) == .new {
            woord.practice5 = newStatus.rawValue
        } else {
            // Shift practice1 to practice4 up and set newStatus to practice5
            woord.practice1 = woord.practice2
            woord.practice2 = woord.practice3
            woord.practice3 = woord.practice4
            woord.practice4 = woord.practice5
            woord.practice5 = newStatus.rawValue
        }
        
        // Check if all practice statuses are "known"
        if [woord.practice1, woord.practice2, woord.practice3, woord.practice4, woord.practice5].allSatisfy({ $0 == Woord.PracticeState.known.rawValue }) {
            woord.isActive = false
            print("\(woord.naam) has reached 'known' status for all practice states and is now inactive.")
        }
    }
}
