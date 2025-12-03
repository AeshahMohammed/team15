//
//  ColoredSection.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 03/12/2025.
//
import SwiftUI

struct ColoredSection: View {
    
    var title: String
    var color: Color
    
    @State private var pressed = false
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring(response: 0.25)) {
                pressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                pressed = false
            }
            print("\(title) tapped")
        }) {
            
            VStack(spacing: 10) {
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: 140, height: 140)
                    .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 3)
                    .scaleEffect(pressed ? 0.93 : 1.0)
                    .opacity(pressed ? 0.85 : 1.0)
            }
        }
        .buttonStyle(.plain)
    }
}
