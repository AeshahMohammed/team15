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
   @Environment(\.dismiss) private var dismiss
   @State private var selectedActivity: Activity? = nil
   
   // Rhythm: red → orange → blue → green (repeat)
   // Rhythm: red → orange → blue → green → yellow (repeat)
   private let activities: [Activity] = [
       Activity(englishName: "story time",   arabicName: "وقت القصة",       emoji: "📖",  color: .red),
       Activity(englishName: "drawing",      arabicName: "الرسم",           emoji: "🎨",  color: .orange.opacity(0.7)),
       Activity(englishName: "dancing",      arabicName: "الرقص",           emoji: "💃",  color: .blue),
       Activity(englishName: "playtime",     arabicName: "وقت اللعب",       emoji: "🧸",  color: .green),
       Activity(englishName: "outside",      arabicName: "الخارج",          emoji: "🌳",  color: .yellow),

       Activity(englishName: "quiet time",   arabicName: "وقت هادئ",        emoji: "🤫",  color: .red),
       Activity(englishName: "music",        arabicName: "الموسيقى",        emoji: "🎵",  color: .orange.opacity(0.7)),
       Activity(englishName: "bath time",    arabicName: "وقت الاستحمام",   emoji: "🛁",  color: .blue),
       Activity(englishName: "snack time",   arabicName: "وقت الوجبة",      emoji: "🍪",  color: .green),
       Activity(englishName: "puzzle",       arabicName: "التركيب",         emoji: "🧩",  color: .yellow),

       Activity(englishName: "blocks",       arabicName: "المكعبات",        emoji: "🧱",  color: .red),
       Activity(englishName: "walk",         arabicName: "المشي",           emoji: "🚶‍♂️", color: .orange.opacity(0.7))
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
           .navigationBarTitleDisplayMode(.large)
           .toolbar {
               
               // Back button
               ToolbarItem(placement: .navigationBarLeading) {
                   Button { dismiss() } label: {
                       HStack {
                           Image(systemName: "chevron.backward")
                           Text(isArabic ? "الرئيسية" : "Home")
                       }
                       .foregroundColor(.black)
                   }
               }
               
               // (Language toggle removed)
           }
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
       .background(
           RoundedRectangle(cornerRadius: 30)
               .fill(activity.color.opacity(0.25))
       )
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
       .background(
           RoundedRectangle(cornerRadius: 20)
               .fill(isSelected ? color.opacity(0.9) : color.opacity(0.6))
       )
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
           case "story time": return ["أبي وقت القصة", "مو أبي وقت القصة", "اقرأ معي"]
           case "drawing": return ["أبي أرسم", "مو أبي أرسم", "ارسم معي"]
           case "dancing": return ["أبي أرقص", "مو أبي أرقص", "ارقص معي"]
           case "playtime": return ["أبي ألعب", "مو أبي ألعب", "العب معي"]
           case "outside": return ["أبي أطلع برا", "مو أبي أطلع", "تعال معي برا"]
           case "quiet time": return ["أبي وقت هدوء", "مو أبي هدوء", "أحتاج مكان هادي"]
           case "music": return ["أبي موسيقى", "مو أبي موسيقى", "شغل موسيقى"]
           case "bath time": return ["أبي أستحم", "مو أبي أستحم", "خلنا نستحم"]
           case "snack time": return ["أبي سناك", "مو أبي سناك", "أبي أكل"]
           case "puzzle": return ["أبي تركيب", "مو أبي تركيب", "خلنا نركب"]
           case "blocks": return ["أبي مكعبات", "مو أبي مكعبات", "خلنا نبني"]
           case "walk": return ["أبي أمشي", "مو أبي أمشي", "امش معي"]
           default: return ["أبي \(displayName)", "مو أبي \(displayName)", "خلنا \(displayName)"]
           }
       } else {
           switch key {
           case "story time": return ["I want story time", "I don’t want story time", "Read with me"]
           case "drawing": return ["I want to draw", "I don’t want to draw", "Draw with me"]
           case "dancing": return ["I want to dance", "I don’t want to dance", "Dance with me"]
           case "playtime": return ["I want to play", "I don’t want to play", "Play with me"]
           case "outside": return ["I want to go outside", "I don’t want to go outside", "Come outside with me"]
           case "quiet time": return ["I want quiet time", "I don’t want quiet time", "I need a calm place"]
           case "music": return ["I want music", "I don’t want music", "Play music"]
           case "bath time": return ["I want a bath", "I don’t want a bath", "Let’s take a bath"]
           case "snack time": return ["I want a snack", "I don’t want a snack", "I want food"]
           case "puzzle": return ["I want a puzzle", "I don’t want a puzzle", "Do it with me"]
           case "blocks": return ["I want blocks", "I don’t want blocks", "Build with me"]
           case "walk": return ["I want a walk", "I don’t want a walk", "Walk with me"]
           default: return ["I want \(activity.englishName)", "I don’t want \(activity.englishName)", "Do it with me"]
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
               
               ScrollView {
                   VStack(spacing: 12) {
                       ForEach(defaultPhrases + userPhrases, id: \.self) { phrase in
                           ActivityPhraseBubble(
                               text: phrase,
                               isSelected: selectedPhrase == phrase,
                               color: activity.color
                           )
                           .onTapGesture {
                               selectedPhrase = phrase
                               speak(phrase)
                           }
                       }
                   }
                   .padding(.horizontal)
               }
               
               HStack {
                   TextField(isArabic ? "أضف جملة خاصة بك" : "Add your own phrase",
                             text: $customPhrase)
                       .textFieldStyle(.roundedBorder)
                       .cornerRadius(12)
                   
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
               }
               .padding(.horizontal)
               
               Button(isArabic ? "إغلاق" : "Close") {
                   dismiss()
               }
               .font(.system(size: 22, weight: .bold))
               .padding(.horizontal, 40)
               .padding(.vertical, 12)
               .background(Capsule().fill(activity.color))
               .foregroundColor(.white)
               .padding(.bottom, 20)
           }
           .padding()
       }
       .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
   }
}

// MARK: - Preview
#Preview {
   activitiespage()
}
