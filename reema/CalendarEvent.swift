import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID()
    let englishTitle: String
    let arabicTitle: String
    let emoji: String
    let timeLabel: String
    let color: Color
}
