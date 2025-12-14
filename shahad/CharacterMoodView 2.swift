//
//  CharacterMoodView.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct CharacterMoodView: View {
    
    @StateObject private var vm = CharacterMoodViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        ZStack {
            
            Color(red: 0.98, green: 0.95, blue: 0.90)
                .ignoresSafeArea()
            
            VStack {
                
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(red: 0.80, green: 0.87, blue: 1.0))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(edges: .bottom)
                    
                    VStack(spacing: 25) {
                        
                        HStack {
                            
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            
                            
                           
                        } .padding(.horizontal, 25)
                            .padding(.top, 20)
                        

                     
                        Image("taifpic")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)    // adjust size
                            .padding(.bottom, 20) // optional spacing before buttons
                                Spacer()
              

                        MoodButton(
                            title: vm.text("Parents Mood", "حالة الوالدين"),
                            action: { vm.toggleParentMood() }
                        )

                        MoodButton(
                            title: vm.text("Child Mood", "حالة الطفل"),
                            action: { vm.toggleChildMood() }
                        )

                        
                        Spacer()
                        
                        Button(action: { dismiss() }) {
                            Text(vm.text("Done", "تم"))
                                .font(.headline)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(30)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                }
            }
        }
        .environment(\.layoutDirection, vm.isArabic ? .rightToLeft : .leftToRight)
    }
}
