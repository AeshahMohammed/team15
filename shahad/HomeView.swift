//
//  HomeView.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    
                    // Header
                    HStack {
                        
                        // Back button (optional)
                        Button(action: {
                            // back action
                        }) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            vm.toggleLanguage()
                        }) {
                            Text(vm.isArabic ? "A/ع" : "ع/A")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.82, green: 0.88, blue: 1.0))
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    
                    // Title
                    Text(vm.title(for: "Pick a section", arabic: "اختر قسماً"))
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 10)
                    
                    
                    // First row
                    HStack(spacing: 40) {
                        
                        ColoredSection(
                            title: vm.title(for: "Activities", arabic: "الأنشطة"),
                            color: Color(red: 0.95, green: 0.97, blue: 0.78),
                            emoji: "🎨"
                        ) {
                            vm.selectedSection = "Activities"
                        }
                        
                        ColoredSection(
                            title: vm.title(for: "Needs", arabic: "الاحتياجات"),
                            color: Color(red: 0.93, green: 0.78, blue: 0.75),
                            emoji: "🧺"
                        ) {
                            vm.selectedSection = "Needs"
                        }
                    }
                    
                    
                    // Second row
                    HStack(spacing: 40) {
                        
                        ColoredSection(
                            title: vm.title(for: "People", arabic: "الأشخاص"),
                            color: Color(red: 0.98, green: 0.86, blue: 0.64),
                            emoji: "🧒🏻"
                        ) {
                            vm.selectedSection = "People"
                        }
                        
                        ColoredSection(
                            title: vm.title(for: "Food", arabic: "الطعام"),
                            color: Color(red: 0.96, green: 0.82, blue: 0.70),
                            emoji: "🍎"
                        ) {
                            vm.selectedSection = "Food"
                        }
                    }
                    
                    
                    // Last section
                    ColoredSection(
                        title: vm.title(for: "Feelings", arabic: "المشاعر"),
                        color: Color(red: 0.88, green: 0.95, blue: 0.98),
                        emoji: "😊"
                    ) {
                        vm.selectedSection = "Feelings"
                    }
                    
                    Spacer()
                }
            }
            .navigationDestination(item: $vm.selectedSection) { section in
                SectionDetailView(sectionName: section)
            }
        }
    }
}
