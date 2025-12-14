import SwiftUI
import Combine

final class CalendarViewModel: ObservableObject {

    @Published var events: [CalendarEvent]
    @Published var completedEvents: Set<UUID> = []

    init() {
        self.events = [
            CalendarEvent(
                englishTitle: "Story time",
                arabicTitle: "وقت القصة",
                emoji: "📖",
                timeLabel: "9:00 – 9:30",
                color: .red
            ),
            CalendarEvent(
                englishTitle: "Playing",
                arabicTitle: "وقت اللعب",
                emoji: "🧸",
                timeLabel: "10:00 – 10:30",
                color: .orange.opacity(0.7)
            ),
            CalendarEvent(
                englishTitle: "Outside",
                arabicTitle: "الخارج",
                emoji: "🌳",
                timeLabel: "11:00 – 11:30",
                color: .blue
            ),
            CalendarEvent(
                englishTitle: "Nap time",
                arabicTitle: "وقت القيلولة",
                emoji: "😴",
                timeLabel: "1:00 – 2:00",
                color: .green
            ),
            CalendarEvent(
                englishTitle: "Study time",
                arabicTitle: "وقت الدراسة",
                emoji: "📚",
                timeLabel: "4:00 – 4:30",
                color: .yellow
            )
        ]
    }

    func toggleCompletion(for event: CalendarEvent) {
        if completedEvents.contains(event.id) {
            completedEvents.remove(event.id)
        } else {
            completedEvents.insert(event.id)
        }
    }

    func addEvent(
        englishTitle: String,
        arabicTitle: String?,
        emoji: String,
        timeLabel: String,
        color: Color
    ) {
        let newEvent = CalendarEvent(
            englishTitle: englishTitle,
            arabicTitle: arabicTitle?.isEmpty == false ? arabicTitle! : englishTitle,
            emoji: emoji.isEmpty ? "⭐️" : emoji,
            timeLabel: timeLabel.isEmpty ? "Any time" : timeLabel,
            color: color
        )
        events.append(newEvent)
    }
}
