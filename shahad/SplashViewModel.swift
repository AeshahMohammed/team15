//
//  SplashViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI
import Combine

class SplashViewModel: ObservableObject {
    
    @Published var animate = false
    @Published var goHome = false
    
    func startAnimation() {
        withAnimation(.easeInOut(duration: 2.3)) {
            animate = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
            self.goHome = true
        }
    }
}
