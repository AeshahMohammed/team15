//
//  HomeViewModel.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//

import SwiftUI
import Combine   //

class HomeViewModel: ObservableObject {

    @AppStorage("isArabic") var isArabic = false
    @Published var selectedSection: String? = nil
    
    func toggleLanguage() {
        withAnimation {
            isArabic.toggle()
        }
    }
    
    func title(for english: String, arabic: String) -> String {
        isArabic ? arabic : english
    }
}
