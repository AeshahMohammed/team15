import SwiftUI

// MARK: - Data Model
struct Need: Identifiable {
    let id = UUID()
    let englishName: String
    let arabicName: String
    let emoji: String
    let color: Color
}

// MARK: - Main Needs Page
struct needspage: View {
    
    @AppStorage("isArabic") private var isArabic = false
    
    private let needs: [Need] = [
        Need(englishName: "Food",     arabicName: "الأكل",        emoji: "🍽️", color: .orange),
        Need(englishName: "Thirsty",  arabicName: "عطشان",        emoji: "🥤", color: .blue),
        Need(englishName: "Bathroom", arabicName: "الحمّام",      emoji: "🚻", color: .teal),
        Need(englishName: "Tired",    arabicName: "متعب",         emoji: "😴", color: .purple),
        Need(englishName: "Help",     arabicName: "أحتاج مساعدة", emoji: "🙋‍♀️", color: .pink),
        Need(englishName: "Sick",     arabicName: "مريض",         emoji: "🤒", color: .green)
    ]
    
    @State private var selectedNeed: Need? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background
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
                                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Cards
                        ForEach(needs) { need in
                            NeedBigCard(need: need, isArabic: isArabic)
                                .onTapGesture {
                                    selectedNeed = need
                                }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle(isArabic ? "الاحتياجات" : "Needs")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedNeed) { need in
                NeedFullScreenView(need: need)
            }
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        }
    }
}

// MARK: - Card View
struct NeedBigCard: View {
    let need: Need
    let isArabic: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            Text(need.emoji)
                .font(.system(size: 60))
            
            Text(isArabic ? need.arabicName : need.englishName)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(need.color.opacity(0.25))
        )
        .padding(.horizontal)
    }
}

// MARK: - Phrase Bubble For Needs
struct NeedPhraseBubble: View {
    let text: String
    let isSelected: Bool
    let color: Color
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .padding(.vertical, 12)
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? color.opacity(0.9) : color.opacity(0.6))
        )
    }
}

// MARK: - Fullscreen View With Phrases (bilingual)
struct NeedFullScreenView: View {
    let need: Need
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isArabic") private var isArabic = false
    
    @State private var selectedPhrase: String? = nil
    @State private var customPhrase: String = ""
    @State private var userPhrases: [String] = []
    
    private var displayName: String {
        isArabic ? need.arabicName : need.englishName
    }
    
    // ✅ FIXED: natural phrases per need in both languages
    private var defaultPhrases: [String] {
        let key = need.englishName.lowercased()
        
        if isArabic {
            switch key {
            case "food":
                return [
                    "أنا جائع",
                    "أريد أن آكل",
                    "لا أريد أن آكل الآن"
                ]
            case "thirsty":
                return [
                    "أنا عطشان",
                    "أريد أن أشرب",
                    "لا أريد أن أشرب الآن"
                ]
            case "bathroom":
                return [
                    "أحتاج الذهاب إلى الحمام",
                    "لا أحتاج الحمام الآن",
                    "من فضلك خذني إلى الحمام"
                ]
            case "tired":
                return [
                    "أنا متعب",
                    "أريد أن أرتاح",
                    "لا أريد أن أرتاح الآن"
                ]
            case "help":
                return [
                    "أحتاج مساعدة",
                    "لا أحتاج مساعدة الآن",
                    "من فضلك ساعدني"
                ]
            case "sick":
                return [
                    "أشعر أنني مريض",
                    "بطني تؤلمني",
                    "أحتاج طبيب"
                ]
            default:
                return [
                    "أحتاج \(displayName)",
                    "لا أحتاج \(displayName)",
                    "أريد \(displayName)"
                ]
            }
        } else {
            switch key {
            case "food":
                return [
                    "I am hungry",
                    "I want food",
                    "I don't want food"
                ]
            case "thirsty":
                return [
                    "I am thirsty",
                    "I want a drink",
                    "I don't want a drink"
                ]
            case "bathroom":
                return [
                    "I need the bathroom",
                    "I don't need the bathroom",
                    "Please take me to the bathroom"
                ]
            case "tired":
                return [
                    "I am tired",
                    "I want to rest",
                    "I don't want to rest"
                ]
            case "help":
                return [
                    "I need help",
                    "I don't need help",
                    "Please help me"
                ]
            case "sick":
                return [
                    "I feel sick",
                    "My body hurts",
                    "I need a doctor"
                ]
            default:
                return [
                    "I need \(need.englishName.lowercased())",
                    "I don't need \(need.englishName.lowercased())",
                    "I want \(need.englishName.lowercased())"
                ]
            }
        }
    }
    
    var body: some View {
        ZStack {
            need.color.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer(minLength: 10)
                
                Text(need.emoji)
                    .font(.system(size: 120))
                
                Text(displayName)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                // phrases
                VStack(spacing: 12) {
                    ForEach(defaultPhrases, id: \.self) { phrase in
                        NeedPhraseBubble(
                            text: phrase,
                            isSelected: selectedPhrase == phrase,
                            color: need.color
                        )
                        .onTapGesture { selectedPhrase = phrase }
                    }
                    
                    ForEach(userPhrases, id: \.self) { phrase in
                        NeedPhraseBubble(
                            text: phrase,
                            isSelected: selectedPhrase == phrase,
                            color: need.color
                        )
                        .onTapGesture { selectedPhrase = phrase }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // add custom phrase
                VStack(spacing: 12) {
                    HStack {
                        TextField(isArabic ? "أضف جملة خاصة بك" : "Add your own phrase",
                                  text: $customPhrase)
                            .textFieldStyle(.roundedBorder)
                        
                        Button(isArabic ? "إضافة" : "Add") {
                            let trimmed = customPhrase.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !trimmed.isEmpty {
                                userPhrases.append(trimmed)
                                customPhrase = ""
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(need.color)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
                
                Button(isArabic ? "إغلاق" : "Close") {
                    dismiss()
                }
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(need.color)
                )
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
    needspage()
}
