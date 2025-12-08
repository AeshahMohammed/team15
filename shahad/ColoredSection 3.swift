//
//  ColoredSection 3.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//

import SwiftUI

struct ColoredSection: View {
    
    var title: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .frame(width: 140, height: 140)
                .shadow(color: .gray.opacity(0.3),
                        radius: 6, x: 0, y: 3)
        }
    }
}
