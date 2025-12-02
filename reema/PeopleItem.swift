//
//  PeopleItem.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 30/11/2025.
//

import SwiftUI

// MARK: - Data Model
struct PeopleItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}

// MARK: - People Page
struct PeoplePage: View {

    private let peopleItems: [PeopleItem] = [
        PeopleItem(name: "mom", emoji: "👩‍🦰", color: .pink),
        PeopleItem(name: "dad", emoji: "👨‍🦱", color: .blue),
        PeopleItem(name: "sister", emoji: "👧", color: .purple),
        PeopleItem(name: "brother", emoji: "👦", color: .green),
        PeopleItem(name: "maid", emoji: "👩‍🍳", color: .cyan),
        PeopleItem(name: "driver", emoji: "🧑‍✈️", color: .orange),

        PeopleItem(name: "grandpa", emoji: "👴", color: .brown),
        PeopleItem(name: "grandma", emoji: "👵", color: .mint),
        PeopleItem(name: "uncle", emoji: "🧔", color: .indigo),
        PeopleItem(name: "auntie", emoji: "👩‍🦱", color: .pink),
        PeopleItem(name: "cousin", emoji: "🧑", color: .teal),
        PeopleItem(name: "teacher", emoji: "👩‍🏫", color: .yellow),
        PeopleItem(name: "doctor", emoji: "👨‍⚕️", color: .red),
        PeopleItem(name: "therapist", emoji: "👩‍⚕️", color: .indigo),

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
                PersonFullscreen(
                    name: item.name,
                    emoji: item.emoji,
                    color: item.color
                )
            }
        }
    }
}

// MARK: - Card View
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
                .fill(color.opacity(0.25))
        )
    }
}

// MARK: - Fullscreen Popup with Phrases
struct PersonFullscreen: View {
    let name: String
    let emoji: String
    let color: Color

    @Environment(\.dismiss) private var dismiss
    @State private var customPhrase: String = ""
    @State private var userPhrases: [String] = []
    @State private var selectedPhrase: String? = nil   // ⭐ for highlight selection

    private var defaultPhrases: [String] {
        [
            "I like my \(name)",
            "I don't like my \(name)",
            "I want my \(name)"
        ]
    }

    var body: some View {
        ZStack {
            color.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 25) {

                // Emoji & Name
                Text(emoji)
                    .font(.system(size: 120))

                Text(name.capitalized)
                    .font(.system(size: 42, weight: .bold))

                // Phrase list (CLICKABLE ONLY)
                VStack(spacing: 12) {

                    // -------- DEFAULT PHRASES --------
                    ForEach(defaultPhrases, id: \.self) { phrase in
                        HStack {
                            Text(phrase)
                                .font(.system(size: 20, weight: .medium))
                                .padding(.vertical, 12)

                            Spacer()

                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedPhrase == phrase ? color.opacity(0.4)
                                                             : color.opacity(0.3))
                        )
                        .onTapGesture { selectedPhrase = phrase }
                    }

                    // -------- USER PHRASES --------
                    ForEach(userPhrases, id: \.self) { phrase in
                        HStack {
                            Text(phrase)
                                .font(.system(size: 20, weight: .medium))
                                .padding(.vertical, 12)

                            Spacer()

                            
                            
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedPhrase == phrase ? color.opacity(0.4)
                                                             : color.opacity(0.3))
                        )
                        .onTapGesture { selectedPhrase = phrase }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Add custom phrase
                HStack {
                    TextField("Add your own phrase", text: $customPhrase)
                        .textFieldStyle(.roundedBorder)

                    Button("Add") {
                        let trimmed = customPhrase.trimmingCharacters(in: .whitespaces)
                        if !trimmed.isEmpty {
                            userPhrases.append(trimmed)
                            customPhrase = ""
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                // Close button
                Button("Close") { dismiss() }
                    .font(.system(size: 22, weight: .bold))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(color))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

#Preview {
    PeoplePage()
}


