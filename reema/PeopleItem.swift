import SwiftUI

struct PeopleItem: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}

struct PeoplePage: View {
    
    private let peopleItems: [PeopleItem] = [
        PeopleItem(name: "mom", emoji: "👩‍🦰", color: .pink),
        PeopleItem(name: "dad", emoji: "👨‍🦱", color: .blue),
        PeopleItem(name: "sister", emoji: "👧", color: .purple),
        PeopleItem(name: "brother", emoji: "👦", color: .green),
        PeopleItem(name: "mail", emoji: "📬", color: .cyan),
        PeopleItem(name: "driver", emoji: "🧑‍✈️", color: .orange),
        
        PeopleItem(name: "grandpa", emoji: "👴", color: .brown),
        PeopleItem(name: "grandma", emoji: "👵", color: .mint),
        PeopleItem(name: "uncle", emoji: "🧔", color: .indigo),
        PeopleItem(name: "cousin", emoji: "🧑", color: .teal),
        
        PeopleItem(name: "teacher", emoji: "👩‍🏫", color: .yellow),
        PeopleItem(name: "doctor", emoji: "👨‍⚕️", color: .red),
        PeopleItem(name: "nurse", emoji: "👩‍⚕️", color: .pink.opacity(0.8)),
        
        PeopleItem(name: "friend", emoji: "🧑‍🤝‍🧑", color: .purple.opacity(0.7)),
        PeopleItem(name: "classmates", emoji: "👨‍👩‍👧‍👦", color: .orange.opacity(0.7)),
        
        PeopleItem(name: "neighbor", emoji: "🏘️", color: .green.opacity(0.7))
    ]
    
    @State private var selectedItem: PeopleItem? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    ForEach(peopleItems) { item in
                        PersonCard(name: item.name,
                                   emoji: item.emoji,
                                   color: item.color)
                            .onTapGesture { selectedItem = item }
                    }
                }
                .padding()
            }
            .navigationTitle("People")
            .sheet(item: $selectedItem) { item in
                PersonFullscreen(name: item.name,
                                 emoji: item.emoji,
                                 color: item.color)
            }
        }
    }
}

// MARK: - Card View (same pastel design as Food/Activity)
struct PersonCard: View {
    let name: String
    let emoji: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            Text(emoji)
                .font(.system(size: 60))
            
            Text(name)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(color.opacity(0.25))  // pastel tint
        )
    }
}

// MARK: - Fullscreen Pop-up (same design)
struct PersonFullscreen: View {
    let name: String
    let emoji: String
    let color: Color
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            color.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 35) {
                Spacer()
                
                Text(emoji)
                    .font(.system(size: 130))
                
                Text(name)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                
                Spacer()
                
                Button("Close") {
                    dismiss()
                }
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .padding(.horizontal, 50)
                .padding(.vertical, 14)
                .background(
                    Capsule().fill(color)
                )
                .foregroundColor(.white)
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}

#Preview {
    PeoplePage()
}
