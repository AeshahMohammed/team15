import SwiftUI

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
}

struct FoodPage: View {
    
    private let foodItems: [FoodItem] = [
        FoodItem(name: "apple", emoji: "🍎"),
        FoodItem(name: "hungry", emoji: "😋"),
        FoodItem(name: "orange", emoji: "🍊"),
        FoodItem(name: "thirsty", emoji: "🥤"),
        FoodItem(name: "blueberry", emoji: "🫐"),
        FoodItem(name: "full", emoji: "😌"),
        FoodItem(name: "strawberry", emoji: "🍓"),
        FoodItem(name: "tomato", emoji: "🍅"),
        FoodItem(name: "raspberry", emoji: "🍇"),
        FoodItem(name: "juice", emoji: "🧃"),
        FoodItem(name: "banana", emoji: "🍌"),
        FoodItem(name: "bread", emoji: "🍞"),
        FoodItem(name: "spice", emoji: "🌶️"),
        FoodItem(name: "rice", emoji: "🍚"),
        FoodItem(name: "salt", emoji: "🧂"),
        FoodItem(name: "chicken", emoji: "🍗"),
        FoodItem(name: "fish", emoji: "🐟"),
        FoodItem(name: "meat", emoji: "🥩"),
        FoodItem(name: "tea", emoji: "🫖"),
        FoodItem(name: "egg", emoji: "🥚"),
        FoodItem(name: "burger", emoji: "🍔"),
        FoodItem(name: "milk", emoji: "🥛"),
        FoodItem(name: "pizza", emoji: "🍕"),
        FoodItem(name: "chocolate", emoji: "🍫")
    ]
    
    @State private var selectedItem: FoodItem? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    ForEach(foodItems) { item in
                        ItemCard(name: item.name, emoji: item.emoji, color: .orange)
                            .onTapGesture { selectedItem = item }
                    }
                }
                .padding()
            }
            .navigationTitle("Food")
            .sheet(item: $selectedItem) { item in
                ItemFullscreen(name: item.name, emoji: item.emoji, color: .orange)
            }
        }
    }
}
