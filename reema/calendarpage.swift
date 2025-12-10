
import SwiftUI

// MARK: - Main Calendar Page (View)
struct calendarpage: View {
    
    @AppStorage("isArabic") private var isArabic = false
    @StateObject private var viewModel = CalendarViewModel()
    
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 22) {
                        
                        // Language toggle
                        HStack {
                            Button(action: {
                                withAnimation {
                                    isArabic.toggle()
                                }
                            }) {
                                Text(isArabic ? "A/ع" : "ع/A")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color(red: 0.82, green: 0.88, blue: 1.0))
                                    .cornerRadius(20)
                                    .shadow(color: .gray.opacity(0.4),
                                            radius: 4, x: 0, y: 2)
                            }
                            
                            Spacer()
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
                
                // Floating + button
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(24)
                        .background(Color.green)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2),
                                radius: 6, x: 0, y: 4)
                        .padding()
                }
            }
            .navigationTitle(isArabic ? "جدولي" : "My calendar")
            .navigationBarTitleDisplayMode(.large)
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
            .sheet(isPresented: $showAddSheet) {
                AddCalendarEventView(
                    isArabic: isArabic,
                    viewModel: viewModel
                )
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
    @State private var emoji: String = ""
    @State private var timeLabel: String = ""
    
    private let colors: [Color] = [.orange, .pink, .green, .yellow, .blue, .teal]
    @State private var colorIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField(isArabic ? "العنوان بالإنجليزية" : "Title (English)",
                          text: $englishTitle)
                    .textFieldStyle(.roundedBorder)
                
                TextField(isArabic ? "العنوان بالعربية (اختياري)" : "Title (Arabic, optional)",
                          text: $arabicTitle)
                    .textFieldStyle(.roundedBorder)
                
                TextField(isArabic ? "الرمز التعبيري (إيموجي)" : "Emoji (e.g. 📖)",
                          text: $emoji)
                    .textFieldStyle(.roundedBorder)
                
                TextField(isArabic ? "الوقت (مثال: 4:00 – 4:30)" : "Time (e.g. 4:00 – 4:30)",
                          text: $timeLabel)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Text(isArabic ? "اللون" : "Color")
                    Spacer()
                    Circle()
                        .fill(colors[colorIndex])
                        .frame(width: 30, height: 30)
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
                
                Button(isArabic ? "إضافة للنشاطات" : "Add to calendar") {
                    let trimmedEN = englishTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedEN.isEmpty else { return }
                    
                    viewModel.addEvent(
                        englishTitle: trimmedEN,
                        arabicTitle: arabicTitle,
                        emoji: emoji,
                        timeLabel: timeLabel,
                        color: colors[colorIndex]
                    )
                    
                    dismiss()
                }
                .font(.system(size: 20, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(
                    Capsule().fill(colors[colorIndex])
                )
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
}

// MARK: - Preview
#Preview {
    calendarpage()
}
