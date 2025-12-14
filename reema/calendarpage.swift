import SwiftUI

// MARK: - Main Calendar Page (View)
struct calendarpage: View {

    @AppStorage("isArabic") private var isArabic = false
    @StateObject private var viewModel = CalendarViewModel()
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color(.systemGray6).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {

                        // Progress bar (MVVM)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(isArabic ? "الإنجاز" : "Progress")
                                    .font(.system(size: 18, weight: .bold))

                                Spacer()

                                Text("\(Int(viewModel.progress * 100))%")
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
                                        .frame(width: geo.size.width * viewModel.progress, height: 14)
                                        .animation(.easeInOut(duration: 0.25), value: viewModel.progress)
                                }
                            }
                            .frame(height: 14)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Cards
                        ForEach(viewModel.events) { event in
                            CalendarCard(
                                event: event,
                                isArabic: isArabic,
                                isDone: viewModel.isCompleted(event)
                            )
                            .onTapGesture {
                                viewModel.toggleCompletion(for: event)
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.bottom)
                }

                // Floating +
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 78, height: 78)
                        .background(Color.green)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.22), radius: 8, x: 0, y: 5)
                }
                .padding(.trailing, 18)
                .padding(.bottom, 18)
            }
            .navigationTitle(isArabic ? "جدولي" : "My calendar")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true) // prevents double back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    OvalBackButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation { isArabic.toggle() }
                    } label: {
                        Text(isArabic ? "A/ع" : "ع/A")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.82, green: 0.88, blue: 1.0))
                            .cornerRadius(14)
                            .shadow(color: .gray.opacity(0.25), radius: 3, x: 0, y: 2)
                    }
                }
            }
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
            .sheet(isPresented: $showAddSheet) {
                AddCalendarEventView(isArabic: isArabic, viewModel: viewModel)
            }
        }
    }
}

// MARK: - Calendar Card
struct CalendarCard: View {
    let event: CalendarEvent
    let isArabic: Bool
    let isDone: Bool

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(event.emoji)
                    .font(.system(size: 38))

                Text(event.timeLabel)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Text(isArabic ? event.arabicTitle : event.englishTitle)
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
                .strokeBorder(isDone ? Color.green.opacity(0.8) : Color.clear, lineWidth: 3)
        )
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: isDone)
    }
}

// MARK: - Add Event Sheet
struct AddCalendarEventView: View {
    @Environment(\.dismiss) private var dismiss

    let isArabic: Bool
    @ObservedObject var viewModel: CalendarViewModel

    @State private var englishTitle: String = ""
    @State private var arabicTitle: String = ""

    private let emojis = ["📖","🧸","🌳","😴","📚","🎵","🍽️","⚽️","🎨","🛁","🚗","⭐️"]
    @State private var selectedEmoji: String = "⭐️"

    @State private var startIndex: Int = 6
    @State private var endIndex: Int = 7

    private let colors: [Color] = [.orange, .pink, .green, .yellow, .blue, .teal]
    @State private var colorIndex: Int = 0

    private var timeLabel: String {
        "\(viewModel.times[startIndex]) – \(viewModel.times[endIndex])"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {

                TextField(isArabic ? "العنوان بالإنجليزية" : "Title (English)", text: $englishTitle)
                    .textFieldStyle(.roundedBorder)

                TextField(isArabic ? "العنوان بالعربية (اختياري)" : "Title (Arabic, optional)", text: $arabicTitle)
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
                                    Circle().fill(selectedEmoji == emoji ? Color.green.opacity(0.3) : Color.clear)
                                )
                                .overlay(
                                    Circle().stroke(selectedEmoji == emoji ? Color.green : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture { selectedEmoji = emoji }
                        }
                    }
                }

                // Time scroll pickers
                VStack(alignment: .leading, spacing: 10) {
                    Text(isArabic ? "الوقت" : "Time")
                        .font(.system(size: 18, weight: .bold))

                    HStack {
                        Picker("", selection: $startIndex) {
                            ForEach(viewModel.times.indices, id: \.self) { i in
                                Text(viewModel.times[i]).tag(i)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 140, height: 120)

                        Picker("", selection: $endIndex) {
                            ForEach(viewModel.times.indices, id: \.self) { i in
                                Text(viewModel.times[i]).tag(i)
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
                    if endIndex <= newValue { endIndex = min(newValue + 1, viewModel.times.count - 1) }
                }
                .onChange(of: endIndex) { _, newValue in
                    if newValue <= startIndex { startIndex = max(newValue - 1, 0) }
                }
                .onAppear {
                    if let nine = viewModel.times.firstIndex(of: "9:00") {
                        startIndex = nine
                        endIndex = min(nine + 1, viewModel.times.count - 1)
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
                        .onTapGesture { colorIndex = (colorIndex + 1) % colors.count }
                }
                .padding(.top, 4)

                Spacer()

                Button(isArabic ? "إضافة للنشاطات" : "Add to calendar") {
                    viewModel.addEventFromSheet(
                        englishTitle: englishTitle,
                        arabicTitle: arabicTitle,
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
                    Button(isArabic ? "إلغاء" : "Cancel") { dismiss() }
                }
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}

// MARK: - Preview
#Preview {
    calendarpage()
        .environmentObject(LanguageViewModel())
}
