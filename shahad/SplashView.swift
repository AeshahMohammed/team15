//
//  SplashView.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//

//
//  SplashView.swift
//  team15
//

import SwiftUI
import AVFoundation   // للصوت

struct SplashView: View {
    
    @StateObject private var vm = SplashViewModel()
    @EnvironmentObject var languageVM: LanguageViewModel
    
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            
            if vm.goHome {
                // بعد السلاش نروح لشاشة الأون بوردينق
                OnboardingView()
                    .environmentObject(languageVM)
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
        .onAppear {
            playGreetingIfNeeded()
        }
    }
    
    // MARK: - Voice Greeting (مرة واحدة لكل جلسة)
    
    private func playGreetingIfNeeded() {
        // ✅ إذا سبق شغلناه في هذه الجلسة لا نعيده
        guard !languageVM.hasPlayedSplashGreeting else { return }
        languageVM.hasPlayedSplashGreeting = true
        
        let (arabicText, englishText) = greetingTexts
        
        let arUtterance = AVSpeechUtterance(string: arabicText)
        arUtterance.voice = AVSpeechSynthesisVoice(language: "ar-SA")
        arUtterance.rate  = 0.47
        
        let enUtterance = AVSpeechUtterance(string: englishText)
        enUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        enUtterance.rate  = 0.47
        
        // إذا اللغة الحالية عربية، نبدأ بالعربي ثم إنجليزي، والعكس صحيح
        if languageVM.current == .arabic {
            speechSynthesizer.speak(arUtterance)
            speechSynthesizer.speak(enUtterance)
        } else {
            speechSynthesizer.speak(enUtterance)
            speechSynthesizer.speak(arUtterance)
        }
    }
    
    private var greetingTexts: (String, String) {
        let arabic = "مرحباً، أنا مساعدك للتواصل. هيا نبدأ رحلتنا معاً."
        let english = "Welcome, I am your communication helper. Let’s start our journey together."
        return (arabic, english)
    }
}

#Preview {
    SplashView()
        .environmentObject(LanguageViewModel())
}
