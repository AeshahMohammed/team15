import SwiftUI

struct StartChoiceView: View {

    let user: UserProfile
    @EnvironmentObject var languageVM: LanguageViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Colors
    private let buttonGreen = Color(hex: "#BBF7BB")
    private let buttonBlue  = Color(hex: "#BBDCFF")

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 28) {

                // MARK: - Top Bar (Back + Language)
                HStack(spacing: 12) {

                    // Back (mirrors position with RTL)
                    if languageVM.current.isRTL {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                        }
                    } else {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }

                    // ✅ Language Button
                    Button {
                        withAnimation {
                            languageVM.current = (languageVM.current == .arabic) ? .english : .arabic
                        }
                    } label: {
                        Text(languageVM.current == .arabic ? "A / ع" : "ع / A")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // MARK: - Greeting
                Text(greetingText)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                // MARK: - Profile Image
                Image("taif")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .padding(.top, 4)

                Spacer().frame(height: 6)

                // MARK: - Communication helper
                NavigationLink {
                    HomeView().environmentObject(languageVM)
                } label: {
                    Text(helperTitle)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(buttonGreen)
                        .cornerRadius(26)
                }
                .padding(.horizontal, 40)

                // MARK: - Tasks board
                NavigationLink {
                    calendarpage()
                } label: {
                    Text(tasksTitle)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(buttonBlue)
                        .cornerRadius(26)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
        .environment(\.layoutDirection,
                     languageVM.current.isRTL ? .rightToLeft : .leftToRight)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Texts
    private var helperTitle: String {
        languageVM.current == .arabic ? "مساعد تواصلي" : "Communication helper"
    }

    private var tasksTitle: String {
        languageVM.current == .arabic ? "جدول المهام" : "Tasks board"
    }

    private var greetingText: String {
        let name = user.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        if languageVM.current == .arabic {
            return name.isEmpty ? "مرحباً 👋" : "مرحباً يا \(name) 👋"
        } else {
            return name.isEmpty ? "Hello 👋" : "Hello \(name) 👋"
        }
    }
}

#Preview {
    StartChoiceView(user: UserProfile(firstName: "", age: 7))
        .environmentObject(LanguageViewModel())
}
