//
//  HomeView.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct HomeView: View {
    @State private var showFeelings = false
    @State private var openPeoplePage = false
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            
            
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    
                    HStack {
                        
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
                                .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        ProfilePicButton()
                            .padding(.trailing, 20)
                    }
                    .padding(.top, 20)
                    
                    
                    Text(vm.title(for: "pick a section", arabic: "اختر قسماً"))
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 10)
                    
                    HStack(spacing: 40) {
                        
                        ColoredSection(
                            title: vm.title(for: "Activiteis", arabic: "الأنشطة"),
                            color: Color(red: 0.95, green: 0.97, blue: 0.78)
                        )
                        
                        ColoredSection(
                            title: vm.title(for: "Needs", arabic: "الاحتياجات"),
                            color: Color(red: 0.93, green: 0.78, blue: 0.75)
                        )
                    }
                    
                    HStack(spacing: 40) {
                        
                        ColoredSection(
                            title: vm.title(for: "People", arabic: "الأشخاص"),
                            color: Color(red: 0.98, green: 0.86, blue: 0.64)
                        )
                        .onTapGesture {
                            openPeoplePage = true
                        }
                        
                        ColoredSection(
                            title: vm.title(for: "Food", arabic: "الطعام"),
                            color: Color(red: 0.96, green: 0.82, blue: 0.70)
                        )
                    }
                    
                    Button {
                        showFeelings = true
                    } label: {
                        ColoredSection(
                            title: vm.title(for: "Feeling", arabic: "المشاعر"),
                            color: Color(red: 0.88, green: 0.95, blue: 0.98)
                        )
                    }
                    .fullScreenCover(isPresented: $showFeelings) {
                        feelingspage()
                    }
                    .fullScreenCover(isPresented: $openPeoplePage) {
                        PeoplePage()
                    }
                    Spacer()
                }
            }
            .environment(\.layoutDirection, vm.isArabic ? .rightToLeft : .leftToRight)
        }
    }
}
