//
//  FoodPage.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct FoodPage: View {

    @StateObject private var viewModel = FoodViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    ForEach(viewModel.foodItems) { item in
                        FoodCard(item: item)
                            .onTapGesture {
                                viewModel.selectedItem = item
                            }
                    }
                }
                .padding()
            }
            .navigationTitle(viewModel.isArabic ? "الطعام" : "Food")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(viewModel.isArabic ? "A" : "ع") {
                        withAnimation { viewModel.isArabic.toggle() }
                    }
                    .font(.title2.bold())
                }
            }
            .sheet(item: $viewModel.selectedItem) { item in
                FoodFullscreen(item: item)
                    .environmentObject(viewModel)
            }
            .environment(
                \.layoutDirection,
                 viewModel.isArabic ? .rightToLeft : .leftToRight
            )
        }
    }
}

#Preview {
    FoodPage()
}
