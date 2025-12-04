//
//  OnboardingViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    
    // MARK: - Input
    @Published var firstName: String = ""
    @Published var age: String = ""
    
    // MARK: - Navigation
    @Published var shouldShowCategorySelection: Bool = false
    
    // MARK: - Errors
    @Published var error: OnboardingError?
    
    // MARK: - User
    @Published private(set) var userProfile: UserProfile?
    
    // MARK: - UI State
    var isExpandedFields: Bool {
        !firstName.isEmpty || !age.isEmpty
    }
    
    // MARK: - Actions
    func didTapLogin() {
        let trimmedName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAge  = age.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            error = .emptyName
            return
        }
        
        guard !trimmedAge.isEmpty else {
            error = .emptyAge
            return
        }
        
        guard let ageInt = Int(trimmedAge) else {
            error = .invalidAge
            return
        }
        
        userProfile = UserProfile(firstName: trimmedName, age: ageInt)
        shouldShowCategorySelection = true
    }
    
    func resetError() {
        error = nil
    }
}
