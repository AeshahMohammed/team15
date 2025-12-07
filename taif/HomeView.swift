//
//  HomeView.swift
//  taif
//
//  Created by shahad alharbi on 10/06/1447 AH.
//
import SwiftUI

@main
struct taifApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}



struct HomeView: View {
    
    @AppStorage("isArabic") private var isArabic = false
    
    var body: some View {
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                HStack {
                    
                    Button(action: {
                        withAnimation {
                            isArabic.toggle()
                        }
                    }) {
                        Text(isArabic ? "A/ع" : "ع/A")
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
                
                Text(isArabic ? "اختر قسماً" : "pick a section")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                
                HStack(spacing: 40) {
                    
                    ColoredSection(
                        title: isArabic ? "الأنشطة" : "Activiteis",
                        color: Color(red: 0.95, green: 0.97, blue: 0.78)
                    )
                    
                    ColoredSection(
                        title: isArabic ? "الاحتياجات" : "Needs",
                        color: Color(red: 0.93, green: 0.78, blue: 0.75)
                    )
                }
                
                HStack(spacing: 40) {
                    
                    ColoredSection(
                        title: isArabic ? "الأشخاص" : "People",
                        color: Color(red: 0.98, green: 0.86, blue: 0.64)
                    )
                    
                    ColoredSection(
                        title: isArabic ? "الطعام" : "Food",
                        color: Color(red: 0.96, green: 0.82, blue: 0.70)
                    )
                }
                
                ColoredSection(
                    title: isArabic ? "المشاعر" : "Feeling",
                    color: Color(red: 0.88, green: 0.95, blue: 0.98)
                )
                
                Spacer()
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}

