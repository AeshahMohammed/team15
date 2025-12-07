//
//  PersonFullscreen.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//
import AVFoundation
import SwiftUI
import Combine

// MARK: - Fullscreen Popup with Phrases
struct PersonFullscreen: View {
    let name: String
    let emoji: String
    let color: Color
    let isArabic: Bool

    @Environment(\.dismiss) private var dismiss
    @State private var customPhrase: String = ""
    @State private var userPhrases: [String] = []
    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var selectedPhrase: String? = nil

    private var translatedName: String {
        isArabic ? PeopleViewModel.arabicName(for: name) : name.capitalized
    }

    // MARK: - Text-to-Speech
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: isArabic ? "ar-SA" : "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

    private var defaultPhrases: [String] {
        if isArabic {
            return [
                "أحب \(translatedName)",
                "لا أحب \(translatedName)",
                "أريد \(translatedName)"
            ]
        } else {
            return [
                "I like my \(name)",
                "I don't like my \(name)",
                "I want my \(name)"
            ]
        }
    }

    var body: some View {
        ZStack {
            color.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 25) {

                // Emoji
                Text(emoji)
                    .font(.system(size: 120))

                // Name
                Text(translatedName)
                    .font(.system(size: 42, weight: .bold))

                // Phrase List
                VStack(spacing: 12) {

                    ForEach(defaultPhrases, id: \.self) { phrase in
                        HStack {
                            Text(phrase)
                                .font(.system(size: 20, weight: .medium))
                                .padding(.vertical, 12)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedPhrase == phrase ? color.opacity(0.4)
                                                               : color.opacity(0.3))
                        )
                        .onTapGesture {
                            selectedPhrase = phrase
                            speak(phrase) // <-- Speak phrase
                        }
                    }

                    ForEach(userPhrases, id: \.self) { phrase in
                        HStack {
                            Text(phrase)
                                .font(.system(size: 20, weight: .medium))
                                .padding(.vertical, 12)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedPhrase == phrase ? color.opacity(0.4)
                                                               : color.opacity(0.3))
                        )
                        .onTapGesture {
                            selectedPhrase = phrase
                            speak(phrase) // <-- Speak phrase
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Add Custom Phrase
                HStack {
                    TextField(isArabic ? "أضف عبارة" : "Add your own phrase", text: $customPhrase)
                        .textFieldStyle(.roundedBorder)

                    Button(isArabic ? "إضافة" : "Add") {
                        let trimmed = customPhrase.trimmingCharacters(in: .whitespaces)
                        if !trimmed.isEmpty {
                            userPhrases.append(trimmed)
                            speak(trimmed) // <-- Speak new phrase immediately
                            customPhrase = ""
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
                .padding(.horizontal)

                // Close Button
                Button(isArabic ? "إغلاق" : "Close") {
                    dismiss()
                }
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Capsule().fill(color))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}
