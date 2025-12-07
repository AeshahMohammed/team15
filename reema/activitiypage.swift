import SwiftUI
import AVFoundation // Needed for TTS

// MARK: - Data Model
struct Activity: Identifiable {
    let id = UUID()
    let englishName: String
    let arabicName: String
    let emoji: String
    let color: Color
}

// MARK: - Main Activities Page
struct activitiespage: View {
    
    @AppStorage("isArabic") private var isArabic = false
    @State private var selectedActivity: Activity? = nil
    
    private let activities: [Activity] = [
        Activity(englishName: "story time", arabicName: "وقت القصة",   emoji: "📖", color: .purple),
        Activity(englishName: "drawing",    arabicName: "الرسم",       emoji: "🎨", color: .orange),
        Activity(englishName: "dancing",    arabicName: "الرقص",       emoji: "💃", color: .pink),
        Activity(englishName: "playtime",   arabicName: "وقت اللعب",   emoji: "🧸", color: .blue),
        Activity(englishName: "outside",    arabicName: "الخارج",      emoji: "🌳", color: .green),
        Activity(englishName: "quiet time", arabicName: "وقت هادئ",    emoji: "🤫", color: .teal)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 22) {
                        ForEach(activities) { activity in
                            ActivityBigCard(activity: activity, isArabic: isArabic)
                                .onTapGesture {
                                    selectedActivity = activity
                                }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle(isArabic ? "الأنشطة" : "Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { withAnimation { isArabic.toggle() } }) {
                        Text(isArabic ? "A/ع" : "ع/A")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.82, green: 0.88, blue: 1.0))
                            .cornerRadius(20)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedActivity) { activity in
                ActivityFullScreenView(activity: activity)
            }
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        }
    }
}

// MARK: - Activity Card
struct ActivityBigCard: View {
    let activity: Activity
    let isArabic: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            Text(activity.emoji)
                .font(.system(size: 60))
            
            Text(isArabic ? activity.arabicName : activity.englishName.capitalized)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 30).fill(activity.color.opacity(0.25)))
        .padding(.horizontal)
    }
}

// MARK: - Activity Phrase Bubble
struct ActivityPhraseBubble: View {
    let text: String
    let isSelected: Bool
    let color: Color
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 20, weight: .medium))
                .padding(.vertical, 12)
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? color.opacity(0.9) : color.opacity(0.6)))
    }
}

// MARK: - Fullscreen Activity View with TTS
struct ActivityFullScreenView: View {
    let activity: Activity
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isArabic") private var isArabic = false
    
    @State private var selectedPhrase: String? = nil
    @State private var customPhrase: String = ""
    @State private var userPhrases: [String] = []
    @State private var synthesizer = AVSpeechSynthesizer()
    
    private var displayName: String { isArabic ? activity.arabicName : activity.englishName }
    
    private var defaultPhrases: [String] {
        let key = activity.englishName.lowercased()
        if isArabic {
            switch key {
            case "story time": return ["أريد وقت القصة","لا أريد وقت القصة","اقرأ معي"]
            case "drawing":    return ["أريد أن أرسم","لا أريد أن أرسم","إرسم معي"]
            case "dancing":    return ["أريد أن أرقص","لا أريد أن أرقص","إرقص معي"]
            case "playtime":   return ["أريد أن ألعب","لا أريد أن ألعب","إلعب معي"]
            case "outside":    return ["أريد أن أخرج للخارج","لا أريد أن أخرج للخارج","تعال معي إلى الخارج"]
            case "quiet time": return ["أريد وقت هادئ","لا أريد وقت هادئ","أحتاج مكان هادئ"]
            default:           return ["أريد \(displayName)","لا أريد \(displayName)","أحب \(displayName)"]
            }
        } else {
            switch key {
            case "story time": return ["I want story time","I don't want story time","Read with me"]
            case "drawing":    return ["I want to draw","I don't want to draw","Draw with me"]
            case "dancing":    return ["I want to dance","I don't want to dance","Dance with me"]
            case "playtime":   return ["I want to play","I don't want to play","Play with me"]
            case "outside":    return ["I want to go outside","I don't want to go outside","Come outside with me"]
            case "quiet time": return ["I want quiet time","I don't want quiet time","I need a calm place"]
            default:           return ["I want \(activity.englishName)","I don't want \(activity.englishName)","I like \(activity.englishName)"]
            }
        }
    }
    
    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: isArabic ? "ar-SA" : "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    var body: some View {
        ZStack {
            activity.color.opacity(0.15).ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text(activity.emoji).font(.system(size: 120))
                Text(displayName).font(.system(size: 42, weight: .bold))
                
                VStack(spacing: 12) {
                    ForEach(defaultPhrases, id: \.self) { phrase in
                        ActivityPhraseBubble(text: phrase,
                                             isSelected: selectedPhrase == phrase,
                                             color: activity.color)
                        .onTapGesture {
                            selectedPhrase = phrase
                            speak(phrase)
                        }
                    }
                    
                    ForEach(userPhrases, id: \.self) { phrase in
                        ActivityPhraseBubble(text: phrase,
                                             isSelected: selectedPhrase == phrase,
                                             color: activity.color)
                        .onTapGesture {
                            selectedPhrase = phrase
                            speak(phrase)
                        }
                    }
                }.padding(.horizontal)
                
                Spacer()
                
                HStack {
                    TextField(isArabic ? "أضف جملة خاصة بك" : "Add your own phrase",
                              text: $customPhrase)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(isArabic ? "إضافة" : "Add") {
                        let trimmed = customPhrase.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty {
                            userPhrases.append(trimmed)
                            customPhrase = ""
                            speak(trimmed)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(activity.color)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }.padding(.horizontal)
                
                Button(isArabic ? "إغلاق" : "Close") {
                    dismiss()
                }
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Capsule().fill(activity.color))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            }.padding()
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}

// MARK: - Preview
#Preview {
    activitiespage()
}
