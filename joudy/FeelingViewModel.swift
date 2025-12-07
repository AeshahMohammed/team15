//
//  FeelingViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//

import SwiftUI
import Combine

final class FeelingViewModel: ObservableObject {
    // Input
    let activity: Feeling

    // Language comes from the presenting view (feelingspage passes it)
    @Published var isArabic: Bool

    // UI state used by FeelingFullScreenView
    @Published var sentences: [String] = []
    @Published var selectedPhrase: String? = nil
    @Published var newText: String = ""

    init(activity: Feeling, isArabic: Bool) {
        self.activity = activity
        self.isArabic = isArabic
        self.sentences = Self.defaultSentences(for: activity.nameEnglish, isArabic: isArabic)
    }

    func toggleSelected(_ phrase: String) {
        if selectedPhrase == phrase {
            selectedPhrase = nil
        } else {
            selectedPhrase = phrase
        }
    }

    func addSentence() {
        let trimmed = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        sentences.append(trimmed)
        newText = ""
    }

    // Default phrases per feeling, bilingual. Keyed by english name.
    static func defaultSentences(for englishName: String, isArabic: Bool) -> [String] {
        let key = englishName.lowercased()

        if isArabic {
            switch key {
            case "happy":
                return ["أنا سعيد", "لست سعيدًا", "أريد أن أكون سعيدًا"]
            case "sad":
                return ["أنا حزين", "لست حزينًا", "لا أريد أن أكون حزينًا"]
            case "scared":
                return ["أنا خائف", "لا أشعر بالأمان", "أحتاج طمأنة"]
            case "angry":
                return ["أنا غاضب", "لا أحب هذا", "أحتاج أن أهدأ"]
            case "excited":
                return ["أنا متحمس", "أشعر بالحماس", "أريد أن أشارك فرحتي"]
            case "shy":
                return ["أنا خجول", "لا أريد التحدث الآن", "أحتاج وقتًا"]
            case "tired":
                return ["أنا متعب", "أريد أن أرتاح", "لا أستطيع الآن"]
            case "proud":
                return ["أنا فخور بنفسي", "لقد فعلتها!", "أنجزت شيئًا رائعًا"]
            case "bored":
                return ["أنا أشعر بالملل", "أريد أن أفعل شيئًا", "هل لديك فكرة؟"]
            case "surprised":
                return ["أنا مندهش", "واو!", "لم أتوقع ذلك"]
            default:
                return ["أشعر بمشاعر", "أريد أن أشارك شعوري", "أحتاج مساعدة للتعبير"]
            }
        } else {
            switch key {
            case "happy":
                return ["I am happy", "I am not happy", "I want to be happy"]
            case "sad":
                return ["I am sad", "I am not sad", "I don't want to be sad"]
            case "scared":
                return ["I am scared", "I don't feel safe", "I need comfort"]
            case "angry":
                return ["I am angry", "I don't like this", "I need to calm down"]
            case "excited":
                return ["I am excited", "I feel excited", "I want to share my joy"]
            case "shy":
                return ["I am shy", "I don't want to talk now", "I need some time"]
            case "tired":
                return ["I am tired", "I want to rest", "I can't right now"]
            case "proud":
                return ["I am proud of myself", "I did it!", "I achieved something great"]
            case "bored":
                return ["I am bored", "I want to do something", "Do you have an idea?"]
            case "surprised":
                return ["I am surprised", "Wow!", "I didn't expect that"]
            default:
                return ["I have feelings", "I want to share my feeling", "I need help expressing"]
            }
        }
    }
}
