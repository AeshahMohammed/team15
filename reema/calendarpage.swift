import SwiftUI

// MARK: - Main Calendar Page (View)
struct calendarpage: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var languageVM: LanguageViewModel
    @AppStorage("isArabic") private var isArabic = false
    @StateObject private var viewModel = CalendarViewModel()

    @State private var showAddSheet = false

    private var progress: Double {
        let total = viewModel.events.count
        guard total > 0 else { return 0 }
        return Double(viewModel.completedEvents.count) / Double(total)
    }

    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottomTrailing) {
                Color(.systemGray6)
                    .ignoresSafeArea()
                    
                ScrollView {
                    VStack(spacing: 16) {

                        // ✅ Progress Bar
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(isArabic ? "الإنجاز" : "Progress")
                                    .font(.system(size: 18, weight: .bold))

                                Spacer()

                                Text("\(Int(progress * 100))%")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.green)
                            }

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.gray.opacity(0.25))
                                        .frame(height: 14)

                                    Capsule()
                                        .fill(Color.green)
                                        .frame(width: geo.size.width * progress, height: 14)
                                        .animation(.easeInOut(duration: 0.25), value: progress)
                                }
                            }
                            .frame(height: 14)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Calendar cards
                        ForEach(viewModel.events) { event in
                            CalendarCard(
                                event: event,
                                isArabic: isArabic,
                                isDone: viewModel.completedEvents.contains(event.id)
                            )
                            .onTapGesture {
                                viewModel.toggleCompletion(for: event)
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.bottom)
                }

                // Floating + button (bigger + lower + perfectly round)
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 78, height: 78)
                        .background(Color.green)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.22),
                                radius: 8, x: 0, y: 5)
                }
                .padding(.trailing, 18)
                .padding(.bottom, 18)
            }
            .navigationTitle(isArabic ? "جدولي" : "My calendar")
            .navigationBarTitleDisplayMode(.large)

            // ✅ Gray Arabic/English button next to the title
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isArabic.toggle()
                    } label: {
                        Text("A / ع")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(14)
                    }
                }
            }

            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
            .sheet(isPresented: $showAddSheet) {
                AddCalendarEventView(
                    isArabic: isArabic,
                    viewModel: viewModel
                )
            }
            // Force English (optional)
            .onAppear {
                isArabic = false
            }
        }
    }
}

// MARK: - Calendar Card View (View)
struct CalendarCard: View {
    let event: CalendarEvent
    let isArabic: Bool
    let isDone: Bool

    var titleText: String {
        isArabic ? event.arabicTitle : event.englishTitle
    }

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(event.emoji)
                    .font(.system(size: 38))

                Text(event.timeLabel)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Text(titleText)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Spacer()

            if isDone {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.green)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(event.color.opacity(isDone ? 0.25 : 0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .strokeBorder(
                    isDone ? Color.green.opacity(0.8) : Color.clear,
                    lineWidth: 3
                )
        )
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: isDone)
    }
}

// MARK: - Add Event Sheet (View)
struct AddCalendarEventView: View {
    @Environment(\.dismiss) private var dismiss

    let isArabic: Bool
    @ObservedObject var viewModel: CalendarViewModel

    @State private var englishTitle: String = ""
    @State private var arabicTitle: String = ""

    // Emoji picker
    private let emojis = ["📖","🧸","🌳","😴","📚","🎵","🍽️","⚽️","🎨","🛁","🚗","⭐️"]
    @State private var selectedEmoji: String = "⭐️"

    // Time picker (scroll)
    private let times: [String] = AddCalendarEventView.buildTimes()
    @State private var startIndex: Int = 6
    @State private var endIndex: Int = 7

    private let colors: [Color] = [.orange, .pink, .green, .yellow, .blue, .teal]
    @State private var colorIndex: Int = 0

    private var timeLabel: String {
        "\(times[startIndex]) – \(times[endIndex])"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {

                TextField(isArabic ? "العنوان بالإنجليزية" : "Title (English)",
                          text: $englishTitle)
                    .textFieldStyle(.roundedBorder)

                TextField(isArabic ? "العنوان بالعربية (اختياري)" : "Title (Arabic, optional)",
                          text: $arabicTitle)
                    .textFieldStyle(.roundedBorder)

                // Emoji picker grid
                VStack(alignment: .leading, spacing: 10) {
                    Text(isArabic ? "اختر رمز" : "Choose an emoji")
                        .font(.system(size: 18, weight: .bold))

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 14) {
                        ForEach(emojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 36))
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(selectedEmoji == emoji ? Color.green.opacity(0.3) : Color.clear)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(selectedEmoji == emoji ? Color.green : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    selectedEmoji = emoji
                                }
                        }
                    }
                }

                // Time scroll picker
                VStack(alignment: .leading, spacing: 10) {
                    Text(isArabic ? "الوقت" : "Time")
                        .font(.system(size: 18, weight: .bold))

                    HStack {
                        Picker("", selection: $startIndex) {
                            ForEach(times.indices, id: \.self) {
                                Text(times[$0]).tag($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 140, height: 120)

                        Picker("", selection: $endIndex) {
                            ForEach(times.indices, id: \.self) {
                                Text(times[$0]).tag($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 140, height: 120)
                    }

                    Text(timeLabel)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 6)
                .onChange(of: startIndex) { _, newValue in
                    if endIndex <= newValue {
                        endIndex = min(newValue + 1, times.count - 1)
                    }
                }
                .onChange(of: endIndex) { _, newValue in
                    if newValue <= startIndex {
                        startIndex = max(newValue - 1, 0)
                    }
                }
                .onAppear {
                    if let nine = times.firstIndex(of: "9:00") {
                        startIndex = nine
                        endIndex = min(nine + 1, times.count - 1)
                    }
                }

                // Color picker
                HStack {
                    Text(isArabic ? "اللون" : "Color")
                    Spacer()
                    Circle()
                        .fill(colors[colorIndex])
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "chevron.left.slash.chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .onTapGesture {
                            colorIndex = (colorIndex + 1) % colors.count
                        }
                }
                .padding(.top, 4)

                Spacer()

                // Add even if English is empty (use Arabic if needed)
                Button(isArabic ? "إضافة للنشاطات" : "Add to calendar") {
                    let trimmedEN = englishTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                    let trimmedAR = arabicTitle.trimmingCharacters(in: .whitespacesAndNewlines)

                    let primaryTitle = !trimmedEN.isEmpty ? trimmedEN : trimmedAR
                    guard !primaryTitle.isEmpty else { return }

                    viewModel.addEvent(
                        englishTitle: primaryTitle,
                        arabicTitle: trimmedAR.isEmpty ? nil : trimmedAR,
                        emoji: selectedEmoji,
                        timeLabel: timeLabel,
                        color: colors[colorIndex]
                    )

                    dismiss()
                }
                .font(.system(size: 20, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Capsule().fill(colors[colorIndex]))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            }
            .padding()
            .navigationTitle(isArabic ? "نشاط جديد" : "New activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(isArabic ? "إلغاء" : "Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }

    // MARK: - Helpers
    private static func buildTimes() -> [String] {
        var result: [String] = []
        for hour in 6...22 {
            result.append("\(hour):00")
            result.append("\(hour):30")
        }
        return result
    }
}

// MARK: - Preview
#Preview {
    calendarpage()
        .environmentObject(LanguageViewModel())
}
