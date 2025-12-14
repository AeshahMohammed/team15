import AVFoundation
import SwiftUI

struct FeelingFullScreenView: View {
    @ObservedObject var viewModel: FeelingViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var synthesizer = AVSpeechSynthesizer()
    
    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: viewModel.isArabic ? "ar-SA" : "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

    var body: some View {
        ZStack {
            viewModel.activity.color.opacity(0.15).ignoresSafeArea()
            
            VStack(spacing: 15) {
                
                VStack(spacing: 15) {
                    Text(viewModel.activity.emoji)
                        .font(.system(size: 120))
                    
                    Text(viewModel.isArabic ? viewModel.activity.nameArabic : viewModel.activity.nameEnglish.capitalized)
                        .font(.system(size: 42, weight: .bold))
                }
                
                // Bubble list
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.sentences, id: \.self) { text in
                            FeelingPhraseBubble(
                                text: text,
                                color: viewModel.selectedPhrase == text
                                    ? viewModel.activity.color
                                    : viewModel.activity.color.opacity(0.3)
                            )
                            .onTapGesture {
                                viewModel.toggleSelected(text)
                                speak(text) // ✅ Speak on tap
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Add phrase section
                VStack(spacing: 12) {
                    HStack {
                        TextField(
                            viewModel.isArabic ? "أضف جملة خاصة بك" : "Add your own phrase",
                            text: $viewModel.newText
                        )
                        .textFieldStyle(.roundedBorder)
                        .cornerRadius(30)
                        
                        Button(viewModel.isArabic ? "إضافة" : "Add") {
                            let newPhrase = viewModel.newText.trimmingCharacters(in: .whitespacesAndNewlines)
                            viewModel.addSentence()
                            if !newPhrase.isEmpty {
                                speak(newPhrase) // ✅ Speak new phrase
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(viewModel.activity.color)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
                
                // Close button
                Button(viewModel.isArabic ? "إغلاق" : "Close") {
                    dismiss()
                }
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Capsule().fill(viewModel.activity.color))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .environment(\.layoutDirection, viewModel.isArabic ? .rightToLeft : .leftToRight)
    }
}
