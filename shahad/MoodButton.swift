//
//  MoodButton.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct MoodButton: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.black)
                .padding(.vertical, 18)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.4))
                .cornerRadius(35)
                .padding(.horizontal, 25)
        }
    }
}