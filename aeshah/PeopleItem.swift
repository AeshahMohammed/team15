//
//  PeopleItem.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI
import Combine

// MARK: - Data Model
struct PeopleItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
}
