//
//  SplashView.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct SplashView: View {
    
    @StateObject private var vm = SplashViewModel()
    
    var body: some View {
        
        ZStack {
            
            if vm.goHome {NavigationStack{
                HomeView()}
            } else {
                
                Color(red: 0.98, green: 0.95, blue: 0.90)
                    .ignoresSafeArea()
                
                Image("taifpic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .offset(
                        x: vm.animate ? -220 : 200,
                        y: vm.animate ? -500 : 380
                    )
                    .opacity(vm.animate ? 1 : 0)
                    .onAppear {
                        vm.startAnimation()
                    }
            }
        }
    }
}
