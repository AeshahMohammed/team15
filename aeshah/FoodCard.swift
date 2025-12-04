//
//  FoodCard.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct FoodCard: View {
    let item: FoodItem
    @Environment(\.layoutDirection) private var direction

    var isArabic: Bool { direction == .rightToLeft }

    var body: some View {
        HStack(spacing: 20) {
            Text(item.emoji)
                .font(.system(size: 60))

            Text(isArabic ? FoodCard.arabicName(for: item.name)
                          : item.name.capitalized)
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

    static func arabicName(for name: String) -> String {
        switch name {
            case "apple": return "تفاح"
            case "hungry": return "جائع"
            case "orange": return "برتقال"
            case "thirsty": return "عطشان"
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
}
