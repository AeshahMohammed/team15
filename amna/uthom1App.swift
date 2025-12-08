//
//  uthom1App.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//



import SwiftUI

struct uthom1App: App {
    
    
    @StateObject private var languageVM = LanguageViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                          .environmentObject(languageVM)
        }
    }
}
