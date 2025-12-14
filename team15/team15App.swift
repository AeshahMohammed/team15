import SwiftUI

@main
struct Team15App: App {
    @StateObject var languageVM = LanguageViewModel()
    @State private var didFinishSplash = false

    var body: some Scene {
        WindowGroup {
            if didFinishSplash {
                OnboardingView()
                    .environmentObject(languageVM)
            } else {
                SplashView(didFinishSplash: $didFinishSplash)
            }
        }
    }
}
