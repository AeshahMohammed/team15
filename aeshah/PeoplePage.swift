//
//  PeoplePage.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//

import SwiftUI
import Combine

// MARK: - People Page
struct PeoplePage: View {

    @StateObject private var viewModel = PeopleViewModel()
    @AppStorage("isArabic") private var isArabic = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    ForEach(viewModel.peopleItems) { item in
                        PersonCard(
                            name: isArabic ? PeopleViewModel.arabicName(for: item.name) : item.name.capitalized,
                            emoji: item.emoji,
                            color: item.color
                        )
                        .onTapGesture { viewModel.select(item) }
                    }
                }
                .padding()
            }
            .navigationTitle(isArabic ? "الأشخاص" : "People")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {

                // ✅ Back button — SAME STYLE AS YOUR ACTIVITIES PAGE
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { } label: {
                        HStack {
                            Text(isArabic ? "الرئيسية  " : " Home ")
                        }
                        .foregroundColor(.black)
                    }
                }

                // ✅ Language toggle — SAME STYLE AS YOUR ACTIVITIES PAGE
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation { isArabic.toggle() }
                    } label: {
                        Text(isArabic ? "A / ع" : "ع / A")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                }
            }
            .sheet(item: $viewModel.selectedItem) { item in
                PersonFullscreen(
                    name: item.name,
                    emoji: item.emoji,
                    color: item.color,
                    isArabic: isArabic
                )
            }
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        }
    }
}

// MARK: - Preview
#Preview {
    PeoplePage()
}
