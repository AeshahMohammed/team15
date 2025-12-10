//
//  LanguageViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//



//
//  LanguageViewModel.swift
//  team15
//

import Foundation
import Combine

class LanguageViewModel: ObservableObject {
    @Published var current: AppLanguage = .english
    
    // ✅ جديد: علشان صوت الترحيب يشتغل مرة واحدة في كل جلسة
    @Published var hasPlayedSplashGreeting: Bool = false
    
    // تبديل اللغة
    func toggleLanguage() {
        current = (current == .english) ? .arabic : .english
    }
    
    // MARK: - نصوص عامة
    var toggleButtonTitle: String { "A/ع" }
    
    var onboardingTitle: String {
        switch current {
        case .arabic:
            return "هل أنتم مستعدون\nللرحلة؟"
        case .english:
            return "Ready to start\nthe journey?"
        }
    }
    
    func namePlaceholder(isCompact: Bool) -> String {
        switch current {
        case .arabic:
            return isCompact ? "الاسم" : "اسم الطفل"
        case .english:
            return isCompact ? "name" : "name: child name"
        }
    }
    
    var agePlaceholder: String {
        switch current {
        case .arabic:  return "العمر"
        case .english: return "age"
        }
    }
    
    var signInTitle: String {
        switch current {
        case .arabic:  return "ابدأ"
        case .english: return "Start"
        }
    }
    
    var errorTitle: String {
        switch current {
        case .arabic:  return "خطأ"
        case .english: return "Error"
        }
    }
    
    var okTitle: String {
        switch current {
        case .arabic:  return "حسناً"
        case .english: return "OK"
        }
    }
    
    func errorMessage(for error: OnboardingError?) -> String {
        guard let error else { return "" }
        
        switch (error, current) {
        case (.emptyName, .arabic):  return "الرجاء إدخال الاسم."
        case (.emptyAge, .arabic):   return "الرجاء إدخال العمر."
        case (.invalidAge, .arabic): return "الرجاء إدخال عمر صحيح (أرقام فقط)."
            
        case (.emptyName, .english):  return "Please enter the name."
        case (.emptyAge, .english):   return "Please enter the age."
        case (.invalidAge, .english): return "Please enter a valid age (numbers only)."
        }
    }
}
