//
//  CategorySelectionView.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//




import SwiftUI

struct CategorySelectionView: View {
    
    @ObservedObject var viewModel: CategorySelectionViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            
            Text("اختر قسم")
                .font(.system(size: 32, weight: .bold))
            
            Text("مرحباً، \(viewModel.user.firstName)")
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.sections, id: \.self) { section in
                    Button {
                        viewModel.didSelectSection(section)
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "#F0F0F0"))
                            .frame(height: 90)
                            .overlay(
                                Text(section)
                                    .font(.body)
                            )
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    let user = UserProfile(firstName: "مها", age: 9)
    let vm = CategorySelectionViewModel(user: user)
    CategorySelectionView(viewModel: vm)
}