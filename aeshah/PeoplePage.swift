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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    ForEach(viewModel.peopleItems) { item in
                        PersonCard(
                            name: viewModel.isArabic ? PeopleViewModel.arabicName(for: item.name) : item.name.capitalized,
                            emoji: item.emoji,
                            color: item.color
                        )
                        .onTapGesture { viewModel.select(item) }
                    }
                }
                .padding()
            }
            .navigationTitle(viewModel.isArabic ? "الأشخاص" : "People")
           
            .sheet(item: $viewModel.selectedItem) { item in
                PersonFullscreen(
                    name: item.name,
                    emoji: item.emoji,
                    color: item.color,
                    isArabic: viewModel.isArabic
                )
            }
            .environment(\.layoutDirection, viewModel.isArabic ? .rightToLeft : .leftToRight)
        }
    }
}

// MARK: - Preview
#Preview {
    PeoplePage()
}
