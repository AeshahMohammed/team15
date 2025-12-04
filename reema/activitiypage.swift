import SwiftUI

// MARK: - Data Model
struct Activity: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}

// MARK: - Main Activities Page
struct activitiespage: View {
    
    private let activities: [Activity] = [
        Activity(name: "story time", emoji: "📖", color: .purple),
        Activity(name: "drawing",    emoji: "🎨", color: .orange),
        Activity(name: "dancing",    emoji: "💃", color: .pink),
        Activity(name: "playtime",   emoji: "🧸", color: .blue),
        Activity(name: "outside",    emoji: "🌳", color: .green),
        Activity(name: "quiet time", emoji: "🤫", color: .teal)
    ]
    
    @State private var selectedActivity: Activity? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Same clean background
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 22) {
                        ForEach(activities) { activity in
                            ActivityBigCard(activity: activity)
                                .onTapGesture {
                                    selectedActivity = activity
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Activities")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedActivity) { activity in
                ActivityFullScreenView(activity: activity)
            }
        }
    }
}

// MARK: - Activity Card
struct ActivityBigCard: View {
    let activity: Activity
    
    var body: some View {
        HStack(spacing: 20) {
            Text(activity.emoji)
                .font(.system(size: 60))
            
            Text(activity.name.capitalized)
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
    }
}

// MARK: - Phrase Bubble (for Activities)
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
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? color.opacity(0.9) : color.opacity(0.6))
        )
    }
}

// MARK: - Fullscreen View With Phrases (same technique as FoodFullscreen)
struct ActivityFullScreenView: View {
    let activity: Activity
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPhrase: String? = nil
    @State private var customPhrase: String = ""
    @State private var userPhrases: [String] = []
    
    private var defaultPhrases: [String] {
        [
            "I like \(activity.name)",
            "I don't like \(activity.name)",
            "I want to do \(activity.name)"
        ]
    }
    
    var body: some View {
        ZStack {
            activity.color.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Text(activity.emoji)
                    .font(.system(size: 120))
                
                Text(activity.name.capitalized)
                    .font(.system(size: 42, weight: .bold))
                
                // PHRASES
                VStack(spacing: 12) {
                    // Default phrases
                    ForEach(defaultPhrases, id: \.self) { phrase in
                        ActivityPhraseBubble(
                            text: phrase,
                            isSelected: selectedPhrase == phrase,
                            color: activity.color
                        )
                        .onTapGesture { selectedPhrase = phrase }
                    }
                    
                    // User-added phrases
                    ForEach(userPhrases, id: \.self) { phrase in
                        ActivityPhraseBubble(
                            text: phrase,
                            isSelected: selectedPhrase == phrase,
                            color: activity.color
                        )
                        .onTapGesture { selectedPhrase = phrase }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // ADD PHRASE
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
                        .background(activity.color)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
                
                // CLOSE
                Button("Close") {
                    dismiss()
                }
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(
                    Capsule().fill(activity.color)
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
    activitiespage()
}
