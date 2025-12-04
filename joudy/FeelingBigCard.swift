//
//  FeelingBigCard.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct FeelingBigCard: View {
    let activity: Feeling
    
    var body: some View {
        HStack(spacing: 20) {
            Text(activity.emoji)
                .font(.system(size: 60))
            
            Text(activity.name.capitalized)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(activity.color.opacity(0.25))
        )
    }
}