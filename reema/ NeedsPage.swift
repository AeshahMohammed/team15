import SwiftUI

// MARK: - Model
struct Need: Identifiable {
    let id = UUID()
    let englishName: String
    let arabicName: String
    let emoji: String
    let color: Color
}

// MARK: - Needs Page (Matched Sizes to Activities)
struct NeedsPage: View {

    @AppStorage("isArabic") private var isArabic = false
    @Environment(\.dismiss) private var dismiss     // ✅ added
    @State private var selectedNeed: Need? = nil

    // Rhythm: red → orange → blue → green → yellow (repeat)
    private let needs: [Need] = [
        Need(englishName: "Food",       arabicName: "الأكل",          emoji: "🍎",  color: .red),
        Need(englishName: "Thirsty",    arabicName: "عطشان",         emoji: "🥤",  color: .orange.opacity(0.7)),
        Need(englishName: "Bathroom",   arabicName: "الحمّام",       emoji: "🚻",  color: .blue),
        Need(englishName: "Tired",      arabicName: "متعب",          emoji: "😌",  color: .green),

        Need(englishName: "Help",       arabicName: "أحتاج مساعدة",   emoji: "🙋‍♀️", color: .yellow),
        Need(englishName: "Sick",       arabicName: "مريض",          emoji: "🤒",  color: .red),
        Need(englishName: "Sad",        arabicName: "زعلان",         emoji: "😢",  color: .orange.opacity(0.7)),
        Need(englishName: "Angry",      arabicName: "زعلان مرة",     emoji: "😡",  color: .blue),

        Need(englishName: "Cold",       arabicName: "بردان",         emoji: "🥶",  color: .green),
        Need(englishName: "Hot",        arabicName: "حران",          emoji: "🥵",  color: .yellow),
        Need(englishName: "Hurt",       arabicName: "ألم",           emoji: "🤕",  color: .red),
        Need(englishName: "Scared",     arabicName: "خايف",          emoji: "😨",  color: .orange.opacity(0.7)),

        Need(englishName: "Sleep",      arabicName: "أبي أنام",      emoji: "🛌",  color: .blue),
        Need(englishName: "Hug",        arabicName: "أبي حضن",       emoji: "🤗",  color: .green),
        Need(englishName: "Break",      arabicName: "استراحة",       emoji: "⏸️",  color: .yellow),
        Need(englishName: "Toothbrush", arabicName: "تفريش",         emoji: "🪥",  color: .red)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 22) {
                        ForEach(needs) { need in
                            NeedBigCard(need: need, isArabic: isArabic)
                                .onTapGesture { selectedNeed = need }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .toolbar {
                                            ToolbarItem(placement: .navigationBarLeading) {
                                                OvalBackButton()
                                            }
                                        }

            .navigationTitle(isArabic ? "الاحتياجات" : "Needs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {

            

                // ❌ Language toggle removed
            }
            .sheet(item: $selectedNeed) { need in
                NeedDetailView(need: need)
            }
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        }
    }
}

// MARK: - Need Card (Matched to ActivityBigCard)
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

// MARK: - Phrase Bubble (Matched to ActivityPhraseBubble)
struct NeedPhraseBubble: View {
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

// MARK: - Fullscreen Need View (Matched to ActivityFullScreenView sizing)
struct NeedDetailView: View {
    let need: Need

    @Environment(\.dismiss) private var dismiss
    @AppStorage("isArabic") private var isArabic = false

    @State private var selectedPhrase: String? = nil

    private var title: String { isArabic ? need.arabicName : need.englishName }

    private var phrases: [String] {
        let key = need.englishName.lowercased()

        if isArabic {
            switch key {
            case "food": return ["أنا جائع", "أبي آكل", "مو الحين"]
            case "thirsty": return ["أنا عطشان", "أبي أشرب", "مو الحين"]
            case "bathroom": return ["أبي الحمام", "خذني للحمام", "مو الحين"]
            case "tired", "sleep": return ["أنا تعبان", "أبي أرتاح", "مو الحين"]
            case "help": return ["أحتاج مساعدة", "ساعدني لو سمحت", "مو الحين"]
            case "sick": return ["أنا مريض", "أحس بألم", "أبي دكتور"]
            case "sad": return ["أنا زعلان", "أبي أرتاح", "مو الحين"]
            case "angry": return ["أنا معصب", "خلني لحالي", "مو الحين"]
            case "cold": return ["أنا بردان", "أبي بطانية", "مو الحين"]
            case "hot": return ["أنا حران", "أبي موية", "مو الحين"]
            case "hurt": return ["أنا أتألم", "هنا يوجعني", "أبي مساعدة"]
            case "scared": return ["أنا خايف", "ابق معي", "مو الحين"]
            case "hug": return ["أبي حضن", "أبي أمان", "مو الحين"]
            case "break": return ["أبي استراحة", "أبي هدوء", "مو الحين"]
            case "toothbrush": return ["أبي أفرّش", "خلنا نفرّش", "مو الحين"]
            default: return ["أبي \(title)", "مو الحين", "ممكن تساعدني"]
            }
        } else {
            switch key {
            case "food": return ["I am hungry", "I want food", "Not now"]
            case "thirsty": return ["I am thirsty", "I want a drink", "Not now"]
            case "bathroom": return ["I need the bathroom", "Take me to the bathroom", "Not now"]
            case "tired", "sleep": return ["I am tired", "I want to rest", "Not now"]
            case "help": return ["I need help", "Please help me", "Not now"]
            case "sick": return ["I feel sick", "I am in pain", "I need a doctor"]
            case "sad": return ["I feel sad", "I want a break", "Not now"]
            case "angry": return ["I feel angry", "Leave me alone", "Not now"]
            case "cold": return ["I am cold", "I want a blanket", "Not now"]
            case "hot": return ["I am hot", "I want water", "Not now"]
            case "hurt": return ["It hurts", "It hurts here", "I need help"]
            case "scared": return ["I am scared", "Stay with me", "Not now"]
            case "hug": return ["I want a hug", "I want comfort", "Not now"]
            case "break": return ["I need a break", "I need quiet", "Not now"]
            case "toothbrush": return ["I want to brush", "Let’s brush teeth", "Not now"]
            default: return ["I want \(title)", "Not now", "Please help me"]
            }
        }
    }

    var body: some View {
        ZStack {
            need.color.opacity(0.15).ignoresSafeArea()

            VStack(spacing: 25) {
                Text(need.emoji)
                    .font(.system(size: 120))

                Text(title)
                    .font(.system(size: 42, weight: .bold))

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(phrases, id: \.self) { phrase in
                            NeedPhraseBubble(
                                text: phrase,
                                isSelected: selectedPhrase == phrase,
                                color: need.color
                            )
                            .onTapGesture { selectedPhrase = phrase }
                        }
                    }
                    .padding(.horizontal)
                }

                Button(isArabic ? "إغلاق" : "Close") {
                    dismiss()
                }
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Capsule().fill(need.color))
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
    NeedsPage()
}
