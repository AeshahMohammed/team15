//
//  HomeView.swift
//  taif
//
//  Created by shahad alharbi on 10/06/1447 AH.
//
import SwiftUI

struct HomeView: View {
    
    @State private var isArabic = false
    
    var body: some View {
        ZStack {
            
            Color(red: 0.98, green: 0.94, blue: 0.90)
                .ignoresSafeArea()

            VStack(spacing: 35) {
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isArabic.toggle()
                        }
                    }) {
                        Text(isArabic ? "A/ع" : "ع/A")
                            .font(.headline)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Color.blue.opacity(0.25))
                            .cornerRadius(15)
                    }
                    .padding(.trailing, 25)
                    .padding(.top, 10)
                }
                
                Text(isArabic ? "اختر قسماً" : "Pick a section")
                    .font(.system(size: 38, weight: .medium))
                    .padding(.top, 5)
                
                HStack(spacing: 50) {
                    SectionButton(
                        title: isArabic ? "الأنشطة" : "Activities",
                        color: Color(red: 0.95, green: 0.97, blue: 0.78)
                    ) {
                        print("Activities tapped")
                    }
                    
                    SectionButton(
                        title: isArabic ? "الاحتياجات" : "Needs",
                        color: Color(red: 0.93, green: 0.78, blue: 0.75)
                    ) {
                        print("Needs tapped")
                    }
                }
                
                HStack(spacing: 50) {
                    SectionButton(
                        title: isArabic ? "الأشخاص" : "People",
                        color: Color(red: 0.98, green: 0.86, blue: 0.64)
                    ) {
                        print("People tapped")
                    }
                    
                    SectionButton(
                        title: isArabic ? "الطعام" : "Food",
                        color: Color(red: 0.96, green: 0.82, blue: 0.70)
                    ) {
                        print("Food tapped")
                    }
                }
                
                SectionButton(
                    title: isArabic ? "المشاعر" : "Feeling",
                    color: Color(red: 0.88, green: 0.95, blue: 0.98)
                ) {
                    print("Feeling tapped")
                }
                
                Spacer()
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}

struct SectionButton: View {
    var title: String
    var color: Color
    var action: () -> Void
    
    @State private var pressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.25)) {
                pressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                pressed = false
            }
            action()
        }) {
            VStack(spacing: 12) {
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(color)
                    .frame(width: 135, height: 135)
                    .scaleEffect(pressed ? 0.93 : 1.0)
                    .opacity(pressed ? 0.85 : 1.0)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

