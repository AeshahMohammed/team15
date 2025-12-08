
//private let buttonLong = Color(hex: "#BCCFFB")   // أزرق


//
//  OnboardingView.swift
//  team15
//
//  Created by Amna on 04/12/2025.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var languageVM: LanguageViewModel
    
    // MARK: - COLORS (HEX)
    private let buttonLong = Color(hex: "#BCCFFB")   // أزرق
    private let fieldNameColor   = Color(hex: "#F7D7CF")   // وردي فاتح لحقل الاسم
    private let buttonGreen      = Color(hex: "#BBF7BB")   // أخضر فاتح لزر "ابدأ / Start"
    private let backgroundBeige  = Color(hex: "#FFF4D9")   // خلفية الصفحة
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                backgroundBeige.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // MARK: - شريط علوي (زر اللغة فقط الآن)
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
                                .background(Color(hex: "#BCCFFB"))
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
                    
                    Spacer().frame(height: 36)
                    
                    // MARK: - حقل الاسم
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
                    
                    Spacer().frame(height: 28)
                    
                    // MARK: - زر ابدأ / Start
                    Button {
                        viewModel.didTapStart()
                    } label: {
                        Text(languageVM.signInTitle)  // ابدأ / Start
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(buttonGreen)
                            .cornerRadius(26)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer().frame(height: 24)
                    
                    // MARK: - شخصية تايف
                    characterArea
                        .frame(height: 260)
                    
                    Spacer(minLength: 0)
                }
            }
            // اتجاه الواجهة حسب اللغة
            .environment(\.layoutDirection,
                         languageVM.current.isRTL ? .rightToLeft : .leftToRight)
            
            // بعد الضغط على "ابدأ" نروح لصفحة الاختيار (الجدول أو المساعد التواصلي)
            .navigationDestination(isPresented: $viewModel.shouldShowHome) {
                if let user = viewModel.userProfile {
                    StartChoiceView(user: user)
                        .environmentObject(languageVM)
                } else {
                    // لو ما كان فيه اسم (احتياط عشان ما يعطيك كراش)
                    StartChoiceView(user: UserProfile(firstName: "", age: 0))
                        .environmentObject(languageVM)
                }
            }
        }
    }
    
    // MARK: - Name Fields
    
    /// الحقل قبل ما يكتب الطفل اسمه (placeholder قصير)
    private var compactNameField: some View {
        pillTextField(
            placeholder: languageVM.namePlaceholder(isCompact: true),
            text: $viewModel.firstName,
            bgColor: fieldNameColor
        )
    }
    
    /// الحقل بعد كتابة الاسم (يتوسع ويصير النص أطول)
    private var expandedNameField: some View {
        pillTextField(
            placeholder: languageVM.namePlaceholder(isCompact: false),
            text: $viewModel.firstName,
            bgColor: fieldNameColor
        )
        .frame(maxWidth: .infinity)
    }
    
    /// دالة مشتركة لستايل حقل الاسم
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
            .foregroundColor(.black)  // اللون اللي يكتب فيه الطفل
    }
    
    // MARK: - شخصية تايف مع الحركة
    private var characterArea: some View {
        ZStack(
            alignment: viewModel.isExpandedFields ? .bottomTrailing : .center
        ) {
            Image(viewModel.isExpandedFields ? "taif1_s" : "taif") // عدلي الأسماء حسب الصور عندكم
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
