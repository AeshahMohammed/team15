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
    @AppStorage("selectedMood") var selectedMood = ""
    @AppStorage("isChildMode") var isChildMode = false
    @AppStorage("childName") var childName = "نجد"
    @AppStorage("childAge") var childAge = "7 سنوات"
    
    @Published var editingName = false
    @Published var editingAge = false
    
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
