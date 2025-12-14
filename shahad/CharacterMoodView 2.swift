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
                
                Spacer().frame(height: 40)
                
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
                            
                            Image("taifpic")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120)
                                .padding(.trailing, 10)
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            if vm.editingName {
                                TextField(vm.text("Enter name", "أدخل الاسم"), text: $vm.childName)
                                    .font(.system(size: 36, weight: .bold))
                                    .padding(8)
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(12)
                                    .frame(maxWidth: 250)
                                
                                Button(vm.text("Save", "حفظ")) {
                                    vm.editingName = false
                                }
                                .font(.headline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(10)
                                
                            } else {
                                HStack(spacing: 8) {
                                    Text(vm.childName)
                                        .font(.system(size: 36, weight: .bold))
                                    
                                    Button(action: { vm.editingName = true }) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 22))
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                }
                            }
                            
                          
                        }
                        .padding(.leading, 25)
                        
                        Spacer().frame(height: 20)
                        
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
