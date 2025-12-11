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
        FoodItem(name: "apple", emoji: "🍎", color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "orange", emoji: "🍊",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "blueberry", emoji: "🫐", color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "full", emoji: "😌",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "strawberry", emoji: "🍓",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "tomato", emoji: "🍅",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "raspberry", emoji: "🍇",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "juice", emoji: "🧃",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "banana", emoji: "🍌",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "bread", emoji: "🍞",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "spice", emoji: "🌶️",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "rice", emoji: "🍚",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "salt", emoji: "🧂",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "chicken", emoji: "🍗",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "fish", emoji: "🐟",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "meat", emoji: "🥩", color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "tea", emoji: "🫖",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "egg", emoji: "🥚",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "burger", emoji: "🍔",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "milk", emoji: "🥛",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "pizza", emoji: "🍕",  color: Color(red: 12.0, green: 0.82, blue: 0.60)),
        FoodItem(name: "chocolate", emoji: "🍫", color: Color(red: 12.0, green: 0.82, blue: 0.60))
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
