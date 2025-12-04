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
                ToolbarItem(placement: .topBarTrailing) {  HStack {
                    Button(action: {
                        withAnimation {
                            viewModel.isArabic.toggle()
                        }
                    }) {
                        Text(viewModel.isArabic ? "A/ع" : "ع/A")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.82, green: 0.88, blue: 1.0))
                            .cornerRadius(20)
                          
                    }.buttonStyle(PlainButtonStyle())
                    
                }
               
                
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
