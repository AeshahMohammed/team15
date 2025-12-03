//
//  Untitled.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 03/12/2025.
//
import SwiftUI

struct SplashView: View {
    
    @State private var animate = false
    @State private var goHome = false
    
    var body: some View {
        
        ZStack {
            
            if goHome {
                HomeView()
            } else {
                
                Color(red: 0.98, green: 0.95, blue: 0.90)
                    .ignoresSafeArea()
                
                Image("taifpic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .offset(
                        x: animate ? -220 : 200,
                        y: animate ? -500 : 380
                    )
                    .opacity(animate ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.3)) {
                            animate = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                            goHome = true
                        }
                    }
            }
        }
    }
}
