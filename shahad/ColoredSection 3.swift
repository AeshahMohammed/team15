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
    var emoji: String
    var onTap: () -> Void

    @State private var pressed = false

    var body: some View {

        Button(action: {
            withAnimation(.spring(response: 0.20)) {
                pressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                pressed = false
            }
            onTap()
        }) {

            VStack(spacing: 15) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)

                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: 150, height: 150)
                    .overlay(
                        Text(emoji).font(.system(size: 55))
                    )
                    .scaleEffect(pressed ? 0.93 : 1.0)
            }
        }
        .buttonStyle(.plain)
    }
}
