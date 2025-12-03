//
//  FoodItem.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 30/11/2025.
//
import SwiftUI

// MARK: - Data Model
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}

// MARK: - Main Food Page
struct FoodPage: View {
    
    private let foodItems: [FoodItem] = [
        FoodItem(name: "apple", emoji: "🍎", color: .red),
        FoodItem(name: "hungry", emoji: "😋", color: .orange),
        FoodItem(name: "orange", emoji: "🍊", color: .orange.opacity(0.7)),
        FoodItem(name: "thirsty", emoji: "🥤", color: .pink),
        FoodItem(name: "blueberry", emoji: "🫐", color: .blue),
        FoodItem(name: "full", emoji: "😌", color: .green),
        FoodItem(name: "strawberry", emoji: "🍓", color: .red.opacity(0.7)),
        FoodItem(name: "tomato", emoji: "🍅", color: .red.opacity(0.6)),
        FoodItem(name: "raspberry", emoji: "🍇", color: .purple),
        FoodItem(name: "juice", emoji: "🧃", color: .yellow),
        FoodItem(name: "banana", emoji: "🍌", color: .yellow.opacity(0.75)),
        FoodItem(name: "bread", emoji: "🍞", color: .brown),
        FoodItem(name: "spice", emoji: "🌶️", color: .red),
        FoodItem(name: "rice", emoji: "🍚", color: .gray),
        FoodItem(name: "salt", emoji: "🧂", color: .blue.opacity(0.5)),
        FoodItem(name: "chicken", emoji: "🍗", color: .orange),
        FoodItem(name: "fish", emoji: "🐟", color: .blue.opacity(0.6)),
        FoodItem(name: "meat", emoji: "🥩", color: .pink),
        FoodItem(name: "tea", emoji: "🫖", color: .green.opacity(0.7)),
        FoodItem(name: "egg", emoji: "🥚", color: .gray.opacity(0.6)),
        FoodItem(name: "burger", emoji: "🍔", color: .brown.opacity(0.7)),
        FoodItem(name: "milk", emoji: "🥛", color: .blue.opacity(0.3)),
        FoodItem(name: "pizza", emoji: "🍕", color: .yellow.opacity(0.8)),
        FoodItem(name: "chocolate", emoji: "🍫", color: .brown.opacity(0.8))
    ]
    
    @State private var selectedItem: FoodItem? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    ForEach(foodItems) { item in
                        FoodCard(item: item)
                            .onTapGesture { selectedItem = item }
                    }
                }
                .padding()
            }
            .navigationTitle("Food")
            .sheet(item: $selectedItem) { item in
                FoodFullscreen(item: item)
            }
        }
    }
}

// MARK: - Card View
struct FoodCard: View {
    let item: FoodItem
    
    var body: some View {
        HStack(spacing: 20) {
            Text(item.emoji)
                .font(.system(size: 60))
            
            Text(item.name.capitalized)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(item.color.opacity(0.25))
        )
    }
}

// MARK: - Phrase Bubble (Full Width)
struct PhraseBubble: View {
    let text: String
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
        .background(color.opacity(0.3))
        .cornerRadius(15)
    }
}

// MARK: - Fullscreen View With Phrases
struct FoodFullscreen: View {
    let item: FoodItem
    @State private var selectedPhrase: String? = nil
    @Environment(\.dismiss) private var dismiss
    
    @State private var customPhrase: String = ""
    @State private var userPhrases: [String] = []
    
    private var defaultPhrases: [String] {
        [
            "I like \(item.name)s",
            "I don't like \(item.name)s",
            "I want \(item.name)s"
        ]
    }
    
    var body: some View {
        ZStack {
            item.color.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Text(item.emoji)
                    .font(.system(size: 120))
                
                Text(item.name.capitalized)
                    .font(.system(size: 42, weight: .bold))
                
                VStack(spacing: 12) {
                    // ----- DEFAULT PHRASES -----
                    ForEach(defaultPhrases, id: \.self) { phrase in
                        PhraseBubble(
                            text: phrase,
                            color: selectedPhrase == phrase ? item.color.opacity(0.9) : item.color.opacity(0.6)
                        )
                        .onTapGesture { selectedPhrase = phrase }
                    }

                    // ----- USER PHRASES -----
                    ForEach(userPhrases, id: \.self) { phrase in
                        PhraseBubble(
                            text: phrase,
                            color: selectedPhrase == phrase ? item.color.opacity(0.9) : item.color.opacity(0.6)
                        )
                        .onTapGesture { selectedPhrase = phrase }
                    }                }
                .padding(.horizontal)
                
                Spacer()
                
                // Add Phrase Section (Lower)
                VStack(spacing: 12) {
                    HStack {
                        TextField("Add your own phrase", text: $customPhrase)
                            .textFieldStyle(.roundedBorder)
                            .cornerRadius(30)

                        Button("Add") {
                            let trimmed = customPhrase.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                userPhrases.append(trimmed)
                                customPhrase = ""
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(item.color)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
                
                Button("Close") { dismiss() }
                    .font(.system(size: 22, weight: .bold))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(
                        Capsule().fill(item.color)
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
    FoodPage()
}
