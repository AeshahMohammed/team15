//
//  AppLanguage.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

enum AppLanguage {
    case arabic
    case english
    
    var isRTL: Bool {
        self == .arabic
    }
}