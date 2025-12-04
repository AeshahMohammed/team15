//
//  OnboardingView.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//



import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var languageVM: LanguageViewModel
    
    @State private var isShowingError = false
    
    // MARK: - COLORS (HEX)
    private let fieldNameColor   = Color(hex: "#F7D7CF")   // وردي فاتح
    private let fieldAgeColor    = Color(hex: "#FFF5BF")   // أصفر باهت
    private let buttonGreen      = Color(hex: "#BBF7BB")   // أخضر فاتح
    private let buttonArbEng      = Color(hex: "#BCCFFB")   // أزرق
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
                            Text(languageVM.toggleButtonTitle)
                                .font(.system(size: 16, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(buttonArbEng )
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    // MARK: - العنوان
                    Text(languageVM.onboardingTitle)
                        .font(.system(size: 34, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 40)
                    
                    // مسافة بين العنوان والحقول
                    Spacer().frame(height: 36)
                    
                    // MARK: - الحقول
                    VStack(spacing: 16) {
                        if viewModel.isExpandedFields {
                            expandedFields
                        } else {
                            compactFields
                        }
                    }
                    .animation(.spring(response: 0.45,
                                       dampingFraction: 0.8),
                               value: viewModel.isExpandedFields)
                    .padding(.horizontal, 30)
                    
                    // مسافة بين الحقول والزر
                    Spacer().frame(height: 28)
                    
                    // MARK: - زر الدخول
                    Button {
                        viewModel.didTapLogin()
                    } label: {
                        Text(languageVM.signInTitle)
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(buttonGreen)
                            .cornerRadius(26)
                    }
                    .padding(.horizontal, 40)
                    
                    // مسافة قبل الشخصية
                    Spacer().frame(height: 24)
                    
                    // MARK: - الشخصية
                    characterArea
                        .frame(height: 260)
                    
                    Spacer(minLength: 0)
                }
            }
            // اتجاه الواجهة حسب اللغة
            .environment(\.layoutDirection,
                         languageVM.current.isRTL ? .rightToLeft : .leftToRight)
            
        
            
            // MARK: - Alert للأخطاء
            .onChange(of: viewModel.error) { newValue in
                isShowingError = newValue != nil
            }
            .alert(languageVM.errorTitle,
                   isPresented: $isShowingError) {
                Button(languageVM.okTitle, role: .cancel) {
                    viewModel.resetError()
                }
            } message: {
                Text(languageVM.errorMessage(for: viewModel.error))
            }
        }
    }
    
    // MARK: - FIELDS
    
    private var compactFields: some View {
        HStack(spacing: 14) {
            pillTextField(
                placeholder: languageVM.namePlaceholder(isCompact: true),
                text: $viewModel.firstName,
                bgColor: fieldNameColor
            )
            
            pillTextField(
                placeholder: languageVM.agePlaceholder,
                text: $viewModel.age,
                bgColor: fieldAgeColor
            )
            .frame(width: 90)
        }
    }
    
    private var expandedFields: some View {
        HStack(spacing: 14) {
            pillTextField(
                placeholder: languageVM.namePlaceholder(isCompact: false),
                text: $viewModel.firstName,
                bgColor: fieldNameColor
            )
            .frame(maxWidth: .infinity)
            
            pillTextField(
                placeholder: languageVM.agePlaceholder,
                text: $viewModel.age,
                bgColor: fieldAgeColor
            )
            .frame(width: 90)
        }
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
    }
    
    // MARK: - منطقة الشخصية مع الحركة
    
    private var characterArea: some View {
        ZStack(
            alignment: viewModel.isExpandedFields ? .bottomTrailing : .center
        ) {
            Image(viewModel.isExpandedFields ? "taif1_s" : "taif")
                .resizable()
                .scaledToFit()
                .frame(width: viewModel.isExpandedFields ? 240 : 260)
                .offset(
                    x: viewModel.isExpandedFields ? 30 : 0,
                    y: viewModel.isExpandedFields ? 25 : 0
                )
                .scaleEffect(viewModel.isExpandedFields ? 1.05 : 1.0)
                .animation(.spring(response: 0.55,
                                   dampingFraction: 0.7),
                           value: viewModel.isExpandedFields)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(LanguageViewModel())
}
