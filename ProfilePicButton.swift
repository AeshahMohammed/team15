//
//  ProfilePicButton.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 03/12/2025.
//
import SwiftUI

struct ProfilePicButton: View {
    
    @State private var pressed = false
    @State private var openPage = false
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring(response: 0.25)) {
                pressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                pressed = false
            }
            openPage = true
        }) {
            Image("taifpic")
                .resizable()
                .scaledToFit()
                .frame(width: 110)
                .scaleEffect(pressed ? 0.93 : 1.0)
                .opacity(pressed ? 0.85 : 1.0)
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $openPage) {
            CharacterMoodView()
        }
    }
}
