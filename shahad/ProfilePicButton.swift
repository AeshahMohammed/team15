//
//  ProfilePicButton.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct ProfilePicButton: View {
    
    @StateObject private var vm = ProfilePicButtonViewModel()
    
    var body: some View {
        
        Button(action: {
            vm.handleTap()
        }) {
            Image("taifpic")
                .resizable()
                .scaledToFit()
                .frame(width: 110)
                .scaleEffect(vm.pressed ? 0.93 : 1.0)
                .opacity(vm.pressed ? 0.85 : 1.0)
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $vm.openPage) {
            CharacterMoodView()
        }
    }
}