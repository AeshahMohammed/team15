import SwiftUI

struct Need: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}

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
                
                // 🌟 NEW BACKGROUND (simple, clean, soft)
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

struct NeedFullScreenView: View {
    let need: Need
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            need.color.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 35) {
                Spacer()
                
                Text(need.emoji)
                    .font(.system(size: 130))
                
                Text(need.name)
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
                        .fill(need.color)
                )
                .foregroundColor(.white)
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}

#Preview {
    needspage()
}

