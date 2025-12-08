
import SwiftUI

@main
struct Team15App: App {
    @StateObject var languageVM = LanguageViewModel()

    var body: some Scene {
        WindowGroup {
            OnboardingView()             // FIRST SCREEN OF YOUR APP
                .environmentObject(languageVM)
        }
    }
}
