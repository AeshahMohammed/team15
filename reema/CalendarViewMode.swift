import SwiftUI
import Combine

final class CalendarViewModel: ObservableObject {

    @Published var events: [CalendarEvent]
    @Published var completedEvents: Set<UUID> = []

    // ✅ MVVM: times list belongs to ViewModel
    let times: [String] = CalendarViewModel.buildTimes()

    init() {
        self.events = [
            CalendarEvent(englishTitle: "Story time", arabicTitle: "وقت القصة", emoji: "📖", timeLabel: "9:00 – 9:30", color: .red),
            CalendarEvent(englishTitle: "Playing",   arabicTitle: "وقت اللعب", emoji: "🧸", timeLabel: "10:00 – 10:30", color: .orange.opacity(0.7)),
            CalendarEvent(englishTitle: "Outside",   arabicTitle: "الخارج",    emoji: "🌳", timeLabel: "11:00 – 11:30", color: .blue),
            CalendarEvent(englishTitle: "Nap time",  arabicTitle: "وقت القيلولة", emoji: "😴", timeLabel: "1:00 – 2:00", color: .green),
            CalendarEvent(englishTitle: "Study time", arabicTitle: "وقت الدراسة", emoji: "📚", timeLabel: "4:00 – 4:30", color: .yellow)
        ]
    }

    // ✅ MVVM: progress computed here
    var progress: Double {
        let total = events.count
        guard total > 0 else { return 0 }
        return Double(completedEvents.count) / Double(total)
    }

    func isCompleted(_ event: CalendarEvent) -> Bool {
        completedEvents.contains(event.id)
    }

    func toggleCompletion(for event: CalendarEvent) {
        if completedEvents.contains(event.id) {
            completedEvents.remove(event.id)
        } else {
            completedEvents.insert(event.id)
        }
    }

    // Original addEvent kept (same signature)
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

    // ✅ MVVM helper for the sheet (keeps view clean)
    func addEventFromSheet(
        englishTitle: String,
        arabicTitle: String,
        emoji: String,
        timeLabel: String,
        color: Color
    ) {
        let trimmedEN = englishTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAR = arabicTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        let primaryTitle = !trimmedEN.isEmpty ? trimmedEN : trimmedAR
        guard !primaryTitle.isEmpty else { return }

        addEvent(
            englishTitle: primaryTitle,
            arabicTitle: trimmedAR.isEmpty ? nil : trimmedAR,
            emoji: emoji,
            timeLabel: timeLabel,
            color: color
        )
    }

    private static func buildTimes() -> [String] {
        var result: [String] = []
        for hour in 6...22 {
            result.append("\(hour):00")
            result.append("\(hour):30")
        }
        return result
    }
}
