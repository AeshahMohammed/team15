//
//  OnboardingViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//

import SwiftUI
import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var shouldShowCategorySelection: Bool = false
    @Published private(set) var userProfile: UserProfile?
    
    //نخزن الاسم في UserDefults عشان نستخدمه في HomeViwe
    @AppStorage("childName") var storedChildName: String = ""
    
    
    // هل الحقل ممتلئ ( لتغيير وضع الشخصية + تمدد الحقل )
    var isExpandedFields: Bool {
        !firstName.isEmpty
    }
    
    func didTapStart() {
        let trimmedName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // يخزن الاسم حتى لو كان فاضي
        storedChildName = trimmedName
        // للحفظ داخل الموديل
        userProfile = UserProfile(firstName: trimmedName, age: 0)
        // تنقل الى HomeView
        shouldShowCategorySelection = true
    }
}
