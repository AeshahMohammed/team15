//
//  feelingspage.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//

import SwiftUI

struct feelingspage: View {

    @AppStorage("isArabic") private var isArabic = false
    @Environment(\.dismiss) private var dismiss

    private let feelings: [Feeling] = [
        Feeling(nameEnglish: "happy",     nameArabic: "سعيد",    emoji: "😄", color: .red),
        Feeling(nameEnglish: "sad",       nameArabic: "حزين",    emoji: "☹️", color: .orange.opacity(0.7)),
        Feeling(nameEnglish: "scared",    nameArabic: "خائف",    emoji: "😨", color: .blue),
        Feeling(nameEnglish: "angry",     nameArabic: "غاضب",    emoji: "😡", color: .green),
        Feeling(nameEnglish: "excited",   nameArabic: "متحمس",   emoji: "😆", color: .yellow),

        Feeling(nameEnglish: "shy",       nameArabic: "خجول",    emoji: "☺️", color: .red),
        Feeling(nameEnglish: "tired",     nameArabic: "متعب",    emoji: "🫩", color: .orange.opacity(0.7)),
        Feeling(nameEnglish: "proud",     nameArabic: "فخور",    emoji: "😌", color: .blue),
        Feeling(nameEnglish: "bored",     nameArabic: "ضجران",   emoji: "🥱", color: .green),
        Feeling(nameEnglish: "surprised", nameArabic: "مندهش",   emoji: "😲", color: .yellow)
    ]

    @State private var selectedFeeling: Feeling? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    ForEach(feelings) { feeling in
                        FeelingBigCard(activity: feeling, isArabic: isArabic)
                            .onTapGesture {
                                selectedFeeling = feeling
                            }
                    }
                }
                .padding()
            }
            .navigationTitle(isArabic ? "المشاعر" : "Feelings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                // Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    OvalBackButton()
                }

                // Language toggle
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation { isArabic.toggle() }
                    } label: {
                        Text(isArabic ? "A / ع" : "ع / A")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.82, green: 0.88, blue: 1.0))
                            .cornerRadius(14)
                            .shadow(color: .gray.opacity(0.25), radius: 3, x: 0, y: 2)
                    }
                }
            }
            .sheet(item: $selectedFeeling) { feeling in
                FeelingFullScreenView(
                    viewModel: FeelingViewModel(activity: feeling, isArabic: isArabic)
                )
            }
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        }
    }
}
