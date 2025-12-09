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
    @State private var openNeedsPage = false
    @State private var openActivitiesPage = false
    @State private var openFoodPage = false
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // MARK: - الهيدر (اللغة + صورة الطفل) *بدون زر رجوع*
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
                    
                    Spacer()
                    
                    ProfilePicButton()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // MARK: - العنوان + الترحيب
                VStack(spacing: 6) {
                    Text(vm.title(for: "pick a section", arabic: "اختر قسماً"))
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text(vm.greetingText)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.black)
                }
                .padding(.top, 8)
                
                // MARK: - الأقسام
                VStack(spacing: 24) {
                    
                    HStack(spacing: 40) {
                        ColoredSection(
                            title: vm.title(for: "Activiteis", arabic: "الأنشطة"),
                            color: Color(red: 0.95, green: 0.97, blue: 0.78)
                        )
                        .onTapGesture { openActivitiesPage = true }

                        ColoredSection(
                            title: vm.title(for: "Needs", arabic: "الاحتياجات"),
                            color: Color(red: 0.93, green: 0.78, blue: 0.75)
                        )
                        .onTapGesture { openNeedsPage = true }
                    }
                    
                    HStack(spacing: 40) {
                        ColoredSection(
                            title: vm.title(for: "People", arabic: "الأشخاص"),
                            color: Color(red: 0.98, green: 0.86, blue: 0.64)
                        )
                        .onTapGesture { openPeoplePage = true }

                        ColoredSection(
                            title: vm.title(for: "Food", arabic: "الطعام"),
                            color: Color(red: 0.96, green: 0.82, blue: 0.70)
                        )
                        .onTapGesture { openFoodPage = true }
                    }
                    
                    // قسم المشاعر
                    Button {
                        showFeelings = true
                    } label: {
                        ColoredSection(
                            title: vm.title(for: "Feeling", arabic: "المشاعر"),
                            color: Color(red: 0.88, green: 0.95, blue: 0.98)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        // MARK: - فتح الشاشات
        .fullScreenCover(isPresented: $showFeelings) { feelingspage() }
        .fullScreenCover(isPresented: $openPeoplePage) { PeoplePage() }
        .fullScreenCover(isPresented: $openNeedsPage) { NeedsPage() }
        .fullScreenCover(isPresented: $openActivitiesPage) { activitiespage() }
        .fullScreenCover(isPresented: $openFoodPage) { FoodPage() }
        .environment(\.layoutDirection, vm.isArabic ? .rightToLeft : .leftToRight)
    }
}
#Preview {
    HomeView()
}
