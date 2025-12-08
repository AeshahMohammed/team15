import SwiftUI

struct OnboardingView: View {

    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var languageVM: LanguageViewModel

    // MARK: - COLORS (HEX)
    private let fieldNameColor   = Color(hex: "#F7D7CF")   // وردي فاتح
    private let buttonGreen      = Color(hex: "#BBF7BB")   // أخضر فاتح
    private let backgroundBeige  = Color(hex: "#FFF4D9")   // بيج خلفية

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundBeige.ignoresSafeArea()

                VStack(spacing: 0) {

                    // MARK: - زر اللغة
                    HStack {
                        Spacer()
                        Button {
                            languageVM.toggleLanguage()
                        } label: {
                            Text("A/ع")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color(hex: "#FFF5BF"))
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    // MARK: - العنوان
                    Text(languageVM.onboardingTitle)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 40)

                    // مسافة بين العنوان وحقل الاسم
                    Spacer().frame(height: 36)

                    // MARK: - حقل الاسم (يتبدل بين صغير وكبير)
                    VStack(spacing: 16) {
                        if viewModel.isExpandedFields {
                            expandedNameField
                        } else {
                            compactNameField
                        }
                    }
                    .animation(
                        .spring(response: 0.45, dampingFraction: 0.8),
                        value: viewModel.isExpandedFields
                    )
                    .padding(.horizontal, 30)

                    // مسافة بين الحقل والزر
                    Spacer().frame(height: 28)

                    // MARK: - زر ابدأ / Start
                    Button {
                        viewModel.didTapStart()     // ✅ هنا المشكلة السابقة كانت didTapLogin()
                    } label: {
                        Text(languageVM.signInTitle)    // يعطي: ابدأ / Start
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(buttonGreen)
                            .cornerRadius(26)
                    }
                    .padding(.horizontal, 40)

                    // مسافة قبل الشخصية
                    Spacer().frame(height: 24)

                    // MARK: - الشخصية (صورة ١ قبل الكتابة، صورة ٢ بعد الكتابة)
                    characterArea
                        .frame(height: 260)

                    Spacer(minLength: 0)
                }
            }
            .environment(\.layoutDirection,
                         languageVM.current.isRTL ? .rightToLeft : .leftToRight)

            // MARK: - الانتقال إلى HomeView
            .navigationDestination(isPresented: $viewModel.shouldShowHome) {
                HomeView()
                    .environmentObject(languageVM)
            }
        }
    }

    // MARK: - Name Fields

    private var compactNameField: some View {
        pillTextField(
            placeholder: languageVM.namePlaceholder(isCompact: true),
            text: $viewModel.firstName,
            bgColor: fieldNameColor
        )
    }

    private var expandedNameField: some View {
        pillTextField(
            placeholder: languageVM.namePlaceholder(isCompact: false),
            text: $viewModel.firstName,
            bgColor: fieldNameColor
        )
        .frame(maxWidth: .infinity)
    }

    private func pillTextField(
        placeholder: String,
        text: Binding<String>,
        bgColor: Color
    ) -> some View {
        TextField(placeholder, text: text)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(bgColor)
            .cornerRadius(22)
            .multilineTextAlignment(.center)
            .font(.system(size: 16))
            .foregroundColor(.black)
    }

    // MARK: - الشخصية

    private var characterArea: some View {
        ZStack(
            alignment: viewModel.isExpandedFields ? .bottomTrailing : .center
        ) {
            Image(viewModel.isExpandedFields ? "character2" : "character1")
                .resizable()
                .scaledToFit()
                .frame(width: viewModel.isExpandedFields ? 240 : 260)
                .offset(
                    x: viewModel.isExpandedFields ? 30 : 0,
                    y: viewModel.isExpandedFields ? 25 : 0
                )
                .scaleEffect(viewModel.isExpandedFields ? 1.05 : 1.0)
                .animation(
                    .spring(response: 0.55, dampingFraction: 0.7),
                    value: viewModel.isExpandedFields
                )
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(LanguageViewModel())
}
