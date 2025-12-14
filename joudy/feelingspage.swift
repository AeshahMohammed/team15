//
//  feelingspage.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//



//
//  feelingspage.swift
//  team15
//
//

import SwiftUI

struct feelingspage: View {
    
    @AppStorage("isArabic") private var isArabic = false
    @Environment(\.dismiss) private var dismiss      // زر الرجوع
    
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
        Feeling(nameEnglish: "surprised", nameArabic: "مندهش",  emoji: "😲", color: .yellow)
    

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
            .toolbar {
                                            ToolbarItem(placement: .navigationBarLeading) {
                                                OvalBackButton()
                                            }
                                        }

            .navigationTitle(isArabic ? "المشاعر" : "Feelings")
            .navigationBarTitleDisplayMode(.large)
            
            .sheet(item: $selectedFeeling) { feeling in
                FeelingFullScreenView(
                    viewModel: FeelingViewModel(activity: feeling, isArabic: isArabic)
                )
            }
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        }
    }
}
