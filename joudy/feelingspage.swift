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
        Feeling(nameEnglish: "happy",     nameArabic: "سعيد",    emoji: "😄", color: .yellow),
        Feeling(nameEnglish: "sad",       nameArabic: "حزين",    emoji: "☹️", color: .blue),
        Feeling(nameEnglish: "scared",    nameArabic: "خائف",    emoji: "😨", color: .purple),
        Feeling(nameEnglish: "angry",     nameArabic: "غاضب",    emoji: "😡", color: .red),
        Feeling(nameEnglish: "excited",   nameArabic: "متحمس",   emoji: "😆", color: .orange),
        Feeling(nameEnglish: "shy",       nameArabic: "خجول",    emoji: "☺️", color: .pink),
        Feeling(nameEnglish: "tired",     nameArabic: "متعب",    emoji: "🫩", color: .teal),
        Feeling(nameEnglish: "proud",     nameArabic: "فخور",    emoji: "😌", color: .blue),
        Feeling(nameEnglish: "bored",     nameArabic: "ضجران",   emoji: "🥱", color: .green),
        Feeling(nameEnglish: "surprised", nameArabic: "مندهش",  emoji: "😲", color: .mint)
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
                
                // زر الرجوع فقط (بدون زر لغة)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text(isArabic ? "الرئيسية" : "Home")
                        }
                        .foregroundColor(.black)
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
