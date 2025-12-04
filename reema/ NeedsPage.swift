import SwiftUI

// MARK: - Data Model
struct Need: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}

// MARK: - Main Needs Page
struct needspage: View {
    
    private let needs: [Need] = [
        Need(name: "Hungry",   emoji: "🍽️", color: .orange),
        Need(name: "Thirsty",  emoji: "🥤", color: .blue),
        Need(name: "Bathroom", emoji: "🚻", color: .teal),
        Need(name: "Tired",    emoji: "😴", color: .purple),
        Need(name: "Help",     emoji: "🙋‍♀️", color: .pink),
        Need(name: "Sick",     emoji: "🤒", color: .green)
    ]
    
    @State private var selectedNeed: Need? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // simple, clean, soft background
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 22) {
                        ForEach(needs) { need in
                            NeedBigCard(need: need)
                                .onTapGesture {
                                    selectedNeed = need
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Needs")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedNeed) { need in
                NeedFullScreenView(need: need)
            }
        }
    }
}

// MARK: - Card View
struct NeedBigCard: View {
    let need: Need
    
    var body: some View {
        HStack(spacing: 20) {
            Text(need.emoji)
                .font(.system(size: 60))
            
            Text(need.name)
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

// MARK: - Fullscreen View With Phrases
struct NeedFullScreenView: View {
    let need: Need
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPhrase: String? = nil
    @State private var customPhrase: String = ""
    @State private var userPhrases: [String] = []
    
    // Default phrases based on the need
    private var defaultPhrases: [String] {
        [
            "I need \(need.name.lowercased())",
            "I don't need \(need.name.lowercased())",
            "I feel \(need.name.lowercased())"
        ]
    }
    
    var body: some View {
        ZStack {
            need.color.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer(minLength: 10)
                
                // Emoji + title
                Text(need.emoji)
                    .font(.system(size: 120))
                
                Text(need.name)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                // Phrases list
                VStack(spacing: 12) {
                    // Default phrases
                    ForEach(defaultPhrases, id: \.self) { phrase in
                        NeedPhraseBubble(
                            text: phrase,
                            isSelected: selectedPhrase == phrase,
                            color: need.color
                        )
                        .onTapGesture { selectedPhrase = phrase }
                    }
                    
                    // User-added phrases
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
                
                // Add custom phrase
                VStack(spacing: 12) {
                    HStack {
                        TextField("Add your own phrase", text: $customPhrase)
                            .textFieldStyle(.roundedBorder)
                        
                        Button("Add") {
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
                
                // Close button
                Button("Close") {
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
    }
}

// MARK: - Preview
#Preview {
    needspage()
}
