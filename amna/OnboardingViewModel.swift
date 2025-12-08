import SwiftUI
import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var shouldShowHome: Bool = false
    @Published private(set) var userProfile: UserProfile?

    // الحقل يتمدّد إذا الاسم غير فاضي
    var isExpandedFields: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // زر "ابدأ / Start"
    func didTapStart() {
        let trimmedName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        userProfile = UserProfile(firstName: trimmedName, age: 0)
        shouldShowHome = true
    }
}
