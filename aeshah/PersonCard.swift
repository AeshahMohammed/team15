//
//  PersonCard.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI
import Combine

// MARK: - Card View
struct PersonCard: View {
    let name: String
    let emoji: String
    let color: Color

    var body: some View {
        HStack(spacing: 20) {
            Text(emoji)
                .font(.system(size: 60))

            Text(name)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(color.opacity(0.25))
        )
    }
}
