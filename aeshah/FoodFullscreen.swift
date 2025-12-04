//
//  FoodFullscreen.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct FoodFullscreen: View {

    let item: FoodItem
    @EnvironmentObject var viewModel: FoodViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPhrase: String? = nil

    var itemName: String {
        viewModel.itemName(item)
    }

    var body: some View {
        ZStack {
            item.color.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 25) {

                Text(item.emoji)
                    .font(.system(size: 120))

                Text(itemName)
                    .font(.system(size: 42, weight: .bold))

                VStack(spacing: 12) {
                    ForEach(viewModel.defaultPhrases, id: \.self) { phrase in
                        PhraseBubble(
                            text: phrase,
                            color: selectedPhrase == phrase
                                ? item.color.opacity(0.9)
                                : item.color.opacity(0.6)
                        )
                        .onTapGesture {
                            selectedPhrase = phrase
                        }
                    }

                    ForEach(viewModel.userPhrases, id: \.self) { phrase in
                        PhraseBubble(
                            text: phrase,
                            color: selectedPhrase == phrase
                                ? item.color.opacity(0.9)
                                : item.color.opacity(0.6)
                        )
                        .onTapGesture {
                            selectedPhrase = phrase
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                VStack(spacing: 12) {
                    HStack {
                        TextField(viewModel.isArabic ?
                                  "أضف عبارة" : "Add your own phrase",
                                  text: $viewModel.customPhrase)
                            .textFieldStyle(.roundedBorder)

                        Button(viewModel.isArabic ? "إضافة" : "Add") {
                            viewModel.addPhrase()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(item.color)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal)

                Button(viewModel.isArabic ? "إغلاق" : "Close") {
                    dismiss()
                }
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
        .environment(
            \.layoutDirection,
             viewModel.isArabic ? .rightToLeft : .leftToRight
        )
    }
}
