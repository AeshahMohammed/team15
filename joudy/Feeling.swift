//
//  Feeling.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import Foundation
import SwiftUI

struct Feeling: Identifiable {
    let id = UUID()
    let nameEnglish: String
    let nameArabic: String
    let emoji: String
    let color: Color
}
