//
//  uthom1App.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//



import SwiftUI

@main
struct uthom1App: App {
    
    // لغة التطبيق – تُستخدم في كل الشاشات
        @StateObject private var languageVM = LanguageViewModel()
        
        var body: some Scene {
            WindowGroup {
                SplashView()                 // ⬅️ نبدأ بسلاش فيو
                    .environmentObject(languageVM)
            }
        }
    }
