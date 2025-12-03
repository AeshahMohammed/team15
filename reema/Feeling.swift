//
//  Feeling.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 03/12/2025.
//
import SwiftUI

// Feelings data model (unchanged)
struct Feeling: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}

struct feelingspage: View {
    
    private let feelings: [Feeling] = [
        Feeling(name: "happy", emoji: "😄", color: .yellow),
        Feeling(name: "sad", emoji: "☹️", color: .blue),
        Feeling(name: "scared", emoji: "😨", color: .purple),
        Feeling(name: "angry", emoji: "😡", color: .red),
        Feeling(name: "excited", emoji: "😆", color: .orange),
        Feeling(name: "shy", emoji: "☺️", color: .pink),
        Feeling(name: "tierd", emoji: "🫩", color: .teal),
        Feeling(name: "proud", emoji: "😌", color: .blue),
        Feeling(name: "bored", emoji: "🥱", color: .green),
        Feeling(name: "surpraise", emoji: "😲", color: .mint)
    ]
    
    @State private var selectedFeeling: Feeling? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 22) {
                        ForEach(feelings) { feeling in
                            FeelingBigCard(activity: feeling)
                                .onTapGesture {
                                    selectedFeeling = feeling
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Feelings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedFeeling) { feeling in
                FeelingFullScreenView(activity: feeling)
            }
        }
    }
}

// Large card (unchanged)
struct FeelingBigCard: View {
    let activity: Feeling
    
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
                .fill(activity.color.opacity(0.25))
        )
    }
}

// -----------------------------
// Matching Phrase Bubble (added)
// -----------------------------
struct FeelingPhraseBubble: View {
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

// Fullscreen view (only modified where we agreed)
// - spacing/emoji/title sizes updated to match Food
// - replaced raw Text bubbles with FeelingPhraseBubble
// - text field and Add button styling aligned with Food
// - Close button styling aligned with Food
struct FeelingFullScreenView: View {
    @State private var selectedPhrase: String? = nil   // ← SINGLE SELECTION
    let activity: Feeling
    @Environment(\.dismiss) private var dismiss
    
    @State private var newText: String = ""
    @State private var sentences: [String] = []
    
    init(activity: Feeling) {
        self.activity = activity
        
        let key = "SavedSentences_\(activity.name)"
        
        if let saved = UserDefaults.standard.stringArray(forKey: key) {
            _sentences = State(initialValue: saved)
            return
        }
        
        let defaults: [String]
        
        switch activity.name {
        case "happy":
            defaults = ["I'm happy", "I'm not happy", "i want to be happy"]
        case "sad":
            defaults = ["I'm sad", "i'm not sad", "i don't want to be sad"]
        case "scared":
            defaults = ["I'm scared", "i'm not scared", "I feel unsafe"]
        case "angry":
            defaults = ["I'm angry", "i'm not angry", "i don't want to be angry"]
        case "excited":
            defaults = ["I'm excited", "i'm not excited", "I can't wait!"]
        case "shy":
            defaults = ["I'm shy", "i'm not shy", "My voice becomes small"]
        case "tierd":
            defaults = ["I'm tired","I need rest", "My energy is low"]
        case "proud":
            defaults = ["I'm proud", "I tried my best", "I deserve this feeling"]
        case "bored":
            defaults = ["I'm bored", "Nothing interests me", "Time is slow", "I need something new"]
        case "surpraise":
            defaults = ["I'm surprised", "I didn't expect that", "Everything changed fast"]
        default:
            defaults = ["I feel something but I can't describe it"]
        }
        
        _sentences = State(initialValue: defaults)
    }
    
    var body: some View {
        ZStack {
            activity.color.opacity(0.15).ignoresSafeArea()
            
            VStack(spacing: 15) {
                
                VStack(spacing: 15) {
                    Text(activity.emoji)
                        .font(.system(size: 120))
                    Text(activity.name.capitalized)
                        .font(.system(size: 42, weight: .bold))
                }
                
                // BUBBLES
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(sentences, id: \.self) { text in
                            FeelingPhraseBubble(
                                text: text,
                                color: selectedPhrase == text
                                    ? activity.color        // selected = solid color
                                    : activity.color.opacity(0.3) // unselected = faded
                            )
                            .onTapGesture {
                                toggleSelected(text)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Add Phrase
                VStack(spacing: 12) {
                    HStack {
                        TextField("Add your own phrase", text: $newText)
                            .textFieldStyle(.roundedBorder)
                            .cornerRadius(30)

                        Button("Add") {
                            addSentence()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(activity.color)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
                
                // Close
                Button("Close") { dismiss() }
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
    
    // SINGLE selection only
    private func toggleSelected(_ phrase: String) {
        if selectedPhrase == phrase {
            selectedPhrase = nil         // tap again → unselect
        } else {
            selectedPhrase = phrase      // always keep only 1 selected
        }
    }

    private func key() -> String { "SavedSentences_\(activity.name)" }
    
    private func save() { UserDefaults.standard.set(sentences, forKey: key()) }
    
    private func addSentence() {
        let text = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        sentences.append(text)
        newText = ""
        save()
    }
    
    private func deleteSentence(_ text: String) {
        sentences.removeAll { $0 == text }
        save()
    }
}



#Preview {
    feelingspage()
}
