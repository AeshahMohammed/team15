//
//  CharacterMoodViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//
import SwiftUI
import Combine

class CharacterMoodViewModel: ObservableObject {

    @AppStorage("isArabic") var isArabic = false
    @AppStorage("selectedMood") var selectedMood = "parent"
    @AppStorage("isChildMode") var isChildMode = false {
        didSet {
            // force SwiftUI to update views when AppStorage changes
            objectWillChange.send()
        }
    }
    @AppStorage("childName") var childName = ""
    
    @Published var editingName = false
    
    func toggleParentMood() {
        selectedMood = "parent"
        isChildMode = false
    }
    
    func toggleChildMood() {
        selectedMood = "child"
        isChildMode = true
    }
    
    func text(_ en: String, _ ar: String) -> String {
        isArabic ? ar : en
    }
}
