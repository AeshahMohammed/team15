//
//  HomeViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @AppStorage("isArabic") var isArabic = false
    
    // تقرآ اسم الطفل المخزون في onbording
    @AppStorage("childName") var childName: String = ""
    
    func toggleLanguage() {
        withAnimation {
            isArabic.toggle()
        }
    }
    
    func title(for english: String, arabic: String) -> String {
        isArabic ? arabic : english
    }
    
    // grating the child
    var greetingText: String {
        let trimmed = childName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        // لو الاسم فاضي ما نظهر اسم الطفل 
        if trimmed.isEmpty {
            return isArabic ? "مرحبا" : "Welcome"
        }else {
            return isArabic ? "مرحبا \(trimmed)" : "Welcome \(trimmed)"
        }
    }
}
