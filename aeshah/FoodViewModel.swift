//
//  FoodViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI
import Combine

class FoodViewModel: ObservableObject {

    @Published var isArabic: Bool = false
    @Published var selectedItem: FoodItem? = nil
    @Published var userPhrases: [String] = []
    @Published var customPhrase: String = ""

    let foodItems: [FoodItem] = [
        FoodItem(name: "apple", emoji: "🍎", color: .red),
        FoodItem(name: "orange", emoji: "🍊", color: .orange.opacity(0.7)),
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

    func arabicName(for name: String) -> String {
        switch name {
            case "apple": return "تفاح"
            case "orange": return "برتقال"
            case "blueberry": return "توت أزرق"
            case "full": return "شبعان"
            case "strawberry": return "فراولة"
            case "tomato": return "طماطم"
            case "raspberry": return "توت"
            case "juice": return "عصير"
            case "banana": return "موز"
            case "bread": return "خبز"
            case "spice": return "بهارات"
            case "rice": return "أرز"
            case "salt": return "ملح"
            case "chicken": return "دجاج"
            case "fish": return "سمك"
            case "meat": return "لحم"
            case "tea": return "شاي"
            case "egg": return "بيض"
            case "burger": return "برغر"
            case "milk": return "حليب"
            case "pizza": return "بيتزا"
            case "chocolate": return "شوكلاتة"
            default: return name
        }
    }

    func itemName(_ item: FoodItem) -> String {
        isArabic ? arabicName(for: item.name) : item.name.capitalized
    }

    var defaultPhrases: [String] {
        guard let item = selectedItem else { return [] }
        let name = itemName(item)

        if isArabic {
            return [
                "أحب \(name)",
                "لا أحب \(name)",
                "أريد \(name)"
            ]
        } else {
            return [
                "I like \(item.name)s",
                "I don't like \(item.name)s",
                "I want \(item.name)s"
            ]
        }
    }

    func addPhrase() {
        let trimmed = customPhrase.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            userPhrases.append(trimmed)
            customPhrase = ""
        }
    }
}
