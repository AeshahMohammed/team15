//
//  ProfilePicButtonViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI
import Combine

class ProfilePicButtonViewModel: ObservableObject {
    
    @Published var pressed = false
    @Published var openPage = false
    
    func handleTap() {
        withAnimation(.spring(response: 0.25)) {
            pressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            self.pressed = false
        }
        openPage = true
    }
}
