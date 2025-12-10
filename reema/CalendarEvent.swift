import SwiftUI

// MARK: - Model
struct CalendarEvent: Identifiable {
    let id = UUID()
    let englishTitle: String
    let arabicTitle: String
    let emoji: String
    let timeLabel: String   // e.g. "9:00 – 9:30"
    let color: Color
}
