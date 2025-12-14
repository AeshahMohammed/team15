//
//  FoodFullscreen.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//
import AVFoundation
import SwiftUI

struct FoodFullscreen: View {

    let item: FoodItem
    @EnvironmentObject var viewModel: FoodViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var selectedPhrase: String? = nil
    @StateObject private var moodVM = CharacterMoodViewModel()


    // MARK: - Text-to-Speech
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: viewModel.isArabic ? "ar-SA" : "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

    // MARK: - Item Name
    var itemName: String {
        viewModel.itemName(item)
    }

    var body: some View {
        ZStack {
            item.color.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 25) {

                // Emoji
                Text(item.emoji)
                    .font(.system(size: 120))

                // Item Name
                Text(itemName)
                    .font(.system(size: 42, weight: .bold))

                // Phrase Bubbles
                VStack(spacing: 12) {
                    ForEach(viewModel.defaultPhrases, id: \.self) { phrase in
                        PhraseBubble(
                            text: phrase,
                            color: selectedPhrase == phrase
                                ? item.color.opacity(0.9)
                                : item.color.opacity(0.6)
                        )
                        .onTapGesture {
                            selectedPhrase = phrase
                            speak(phrase) // <-- Speak on tap
                        }
                    }

                    ForEach(viewModel.userPhrases, id: \.self) { phrase in
                        PhraseBubble(
                            text: phrase,
                            color: selectedPhrase == phrase
                                ? item.color.opacity(0.9)
                                : item.color.opacity(0.6)
                        )
                        .onTapGesture {
                            selectedPhrase = phrase
                            speak(phrase) // <-- Speak on tap
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Add Custom Phrase
                VStack(spacing: 12) {
                    HStack {
                        // TextField — disabled if in child mode
                        TextField(
                            viewModel.isArabic ? "أضف عبارة" : "Add your own phrase",
                            text: $viewModel.customPhrase
                        )
                        .textFieldStyle(.roundedBorder)
                        .disabled(moodVM.isChildMode) // disable in child mode

                        // Add button — disabled if in child mode
                        Button(action: {
                            if !moodVM.isChildMode && !viewModel.customPhrase.trimmingCharacters(in: .whitespaces).isEmpty {
                                viewModel.addPhrase()
                                speak(viewModel.customPhrase)
                            }
                        }) {
                            Text(viewModel.isArabic ? "إضافة" : "Add")
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .frame(minHeight: 44)
                                .background(moodVM.isChildMode ? Color.gray : item.color) // gray if disabled
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                        .disabled(moodVM.isChildMode) // disable button in child mode
                    }
                }
                .padding(.horizontal)

                // Close Button
                Button(viewModel.isArabic ? "إغلاق" : "Close") {
                    dismiss()
                }
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Capsule().fill(item.color))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .environment(
            \.layoutDirection,
             viewModel.isArabic ? .rightToLeft : .leftToRight
        )
    }
}

