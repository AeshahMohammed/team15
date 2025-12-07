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
                        TextField(
                            viewModel.isArabic ? "أضف عبارة" : "Add your own phrase",
                            text: $viewModel.customPhrase
                        )
                        .textFieldStyle(.roundedBorder)

                        Button(viewModel.isArabic ? "إضافة" : "Add") {
                            viewModel.addPhrase()
                            // Speak the new phrase immediately
                            if !viewModel.customPhrase.isEmpty {
                                speak(viewModel.customPhrase)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(item.color)
                        .foregroundColor(.white)
                        .cornerRadius(30)
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

