//
//  FeelingPhraseBubble.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct FeelingPhraseBubble: View {
    let text: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 20, weight: .medium))
                .padding(.vertical, 12)
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.3))
        .cornerRadius(15)
    }
}