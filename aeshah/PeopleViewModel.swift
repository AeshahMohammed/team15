//
//  PeopleViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI
import Combine

final class PeopleViewModel: ObservableObject {
    // MARK: - Published state (moved from view)
    @Published var isArabic: Bool = false
    @Published var selectedItem: PeopleItem? = nil

    // People list (moved from view)
    @Published var peopleItems: [PeopleItem] = [
        PeopleItem(name: "mom", emoji: "👩‍🦰", color: .red),
        PeopleItem(name: "dad", emoji: "👨‍🦱", color: .orange.opacity(0.7)),
        PeopleItem(name: "sister", emoji: "👧", color:.blue),
        PeopleItem(name: "brother", emoji: "👦", color: .green),
        PeopleItem(name: "maid", emoji: "👩‍🍳", color:.red),
        PeopleItem(name: "driver", emoji: "🧑‍✈️", color: .orange.opacity(0.7)),

        PeopleItem(name: "grandpa", emoji: "👴", color: .blue),
        PeopleItem(name: "grandma", emoji: "👵", color: .green),
        PeopleItem(name: "uncle", emoji: "🧔", color: .red),
        PeopleItem(name: "auntie", emoji: "👩‍🦱", color:.orange.opacity(0.7)),
        PeopleItem(name: "cousin", emoji: "🧑", color: .blue),
        PeopleItem(name: "teacher", emoji: "👩‍🏫", color: .green),
        PeopleItem(name: "doctor", emoji: "👨‍⚕️", color: .red),
        PeopleItem(name: "therapist", emoji: "👩‍⚕️", color: .orange.opacity(0.7)),

        PeopleItem(name: "friend", emoji: "🧑‍🤝‍🧑", color: .blue),
        PeopleItem(name: "classmates", emoji: "👨‍👩‍👧‍👦",color: .green),
        PeopleItem(name: "neighbor", emoji: "🏘️", color: .red)
    ]

    // MARK: - Arabic lookup moved here
    static func arabicName(for name: String) -> String {
        switch name {
        case "mom": return "أمي"
        case "dad": return "أبي"
        case "sister": return "أختي"
        case "brother": return "أخي"
        case "maid": return "الخادمة"
        case "driver": return "السائق"
        case "grandpa": return "جدي"
        case "grandma": return "جدتي"
        case "uncle": return "عمي"
        case "auntie": return "عمتي"
        case "cousin": return "ابن عمي"
        case "teacher": return "المعلمة"
        case "doctor": return "الدكتور"
        case "therapist": return "الأخصائية"
        case "friend": return "صديقي"
        case "classmates": return "زملائي"
        case "neighbor": return "جارنا"
        default: return name
        }
    }

    // Small helpers (kept expressive so view code remains simple)
    func toggleLanguage() {
        withAnimation { isArabic.toggle() }
    }

    func select(_ item: PeopleItem) {
        selectedItem = item
    }

    func dismissSelection() {
        selectedItem = nil
    }
}
