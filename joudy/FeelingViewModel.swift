//
//  FeelingViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI
import Combine

class FeelingViewModel: ObservableObject {
    @Published var selectedPhrase: String? = nil
    @Published var sentences: [String] = []
    @Published var newText: String = ""
    
    let activity: Feeling
    
    init(activity: Feeling) {
        self.activity = activity
        self.sentences = FeelingViewModel.defaultSentences(for: activity.name)
    }
    
    // All default options per feeling
    static func defaultSentences(for name: String) -> [String] {
        switch name {
        case "happy":
            return ["I'm happy", "I'm not happy", "I want to be happy"]
        case "sad":
            return ["I'm sad", "I'm not sad", "I don't want to be sad"]
        case "scared":
            return ["I'm scared", "I'm not scared", "I feel unsafe"]
        case "angry":
            return ["I'm angry", "I'm not angry", "I don't want to be angry"]
        case "excited":
            return ["I'm excited", "I'm not excited", "I can't wait!"]
        case "shy":
            return ["I'm shy", "I'm not shy", "My voice becomes small"]
        case "tierd":
            return ["I'm tired", "I need rest", "My energy is low"]
        case "proud":
            return ["I'm proud", "I tried my best", "I deserve this feeling"]
        case "bored":
            return ["I'm bored", "Nothing interests me", "Time is slow", "I need something new"]
        case "surpraise":
            return ["I'm surprised", "I didn't expect that", "Everything changed fast"]
        default:
            return ["I feel something but I can't describe it"]
        }
    }
    
    // Toggle single selection only
    func toggleSelected(_ phrase: String) {
        if selectedPhrase == phrase {
            selectedPhrase = nil
        } else {
            selectedPhrase = phrase
        }
    }
    
    // Add new user phrase (no saving!)
    func addSentence() {
        let text = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        sentences.append(text)
        newText = ""
    }
}
