import SwiftUI

struct Activity: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}

struct activitiespage: View {
    
    private let activities: [Activity] = [
        Activity(name: "Story Time", emoji: "📖", color: .purple),
        Activity(name: "Drawing", emoji: "🎨", color: .orange),
        Activity(name: "Dancing", emoji: "💃", color: .pink),
        Activity(name: "Playtime", emoji: "🧸", color: .blue),
        Activity(name: "Outside", emoji: "🌳", color: .green),
        Activity(name: "Quiet Time", emoji: "🤫", color: .teal)
    ]
    
    @State private var selectedActivity: Activity? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // 🌟 SAME CLEAN BACKGROUND
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

// MARK: - Activity Card (same style as NeedBigCard)

struct ActivityBigCard: View {
    let activity: Activity
    
    var body: some View {
        HStack(spacing: 20) {
            Text(activity.emoji)
                .font(.system(size: 60))
            
            Text(activity.name)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(activity.color.opacity(0.25))  // 🎨 Same soft pastel card style
        )
    }
}

// MARK: - Fullscreen (same design as NeedFullScreenView)

struct ActivityFullScreenView: View {
    let activity: Activity
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            activity.color.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 35) {
                Spacer()
                
                Text(activity.emoji)
                    .font(.system(size: 130))
                
                Text(activity.name)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Close") {
                    dismiss()
                }
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .padding(.horizontal, 50)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(activity.color)
                )
                .foregroundColor(.white)
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}

#Preview {
    activitiespage()
}

