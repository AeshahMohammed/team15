// CharacterMoodView.swift

import SwiftUI

struct CharacterMoodView: View {

    @AppStorage("isArabic") private var isArabic = false

    @AppStorage("selectedMood") private var selectedMood: String = ""
    @AppStorage("isChildMode") private var isChildMode: Bool = false
    @AppStorage("childName") private var childName: String = "نجد"
    @AppStorage("childAge") private var childAge: String = "7 سنوات"

    @Environment(\.dismiss) var dismiss

    @State private var editingName = false
    @State private var editingAge = false

    var body: some View {

        ZStack {

            Color(red: 0.98, green: 0.95, blue: 0.90)
                .ignoresSafeArea()

            VStack {

                Spacer().frame(height: 40)

                ZStack {

                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(red: 0.80, green: 0.87, blue: 1.0))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(edges: .bottom)

                    VStack(spacing: 25) {

                        HStack {

                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.black)
                            }

                            Spacer()

                            Image("taifpic")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120)
                                .padding(.trailing, 10)
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, 20)

                        VStack(alignment: .leading, spacing: 10) {

                            if editingName {

                                TextField(isArabic ? "أدخل الاسم" : "Enter name",
                                          text: $childName)
                                    .font(.system(size: 36, weight: .bold))
                                    .padding(8)
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(12)
                                    .frame(maxWidth: 250)

                                Button(isArabic ? "حفظ" : "Save") { editingName = false }
                                    .font(.headline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(10)

                            } else {

                                HStack(spacing: 8) {
                                    Text(childName)
                                        .font(.system(size: 36, weight: .bold))

                                    Button(action: { editingName = true }) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 22))
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                }
                            }

                            if editingAge {

                                TextField(isArabic ? "أدخل العمر" : "Enter age",
                                          text: $childAge)
                                    .font(.system(size: 22))
                                    .padding(8)
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(12)
                                    .frame(maxWidth: 200)

                                Button(isArabic ? "حفظ" : "Save") { editingAge = false }
                                    .font(.headline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(10)

                            } else {

                                HStack(spacing: 8) {
                                    Text(childAge)
                                        .font(.system(size: 22))

                                    Button(action: { editingAge = true }) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                }
                            }
                        }
                        .padding(.leading, 25)

                        Spacer().frame(height: 20)

                        MoodButton(
                            title: isArabic ? "حالة الوالدين" : "Parents Mood",
                            action: {
                                selectedMood = "parent"
                                isChildMode = false
                            }
                        )

                        MoodButton(
                            title: isArabic ? "حالة الطفل" : "Child Mood",
                            action: {
                                selectedMood = "child"
                                isChildMode = true
                            }
                        )

                        Spacer()

                        Button(action: { dismiss() }) {
                            Text(isArabic ? "تم" : "Done")
                                .font(.headline)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(30)
                        }

                        Spacer().frame(height: 20)
                    }
                }
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
}

struct MoodButton: View {

    var title: String
    var action: () -> Void

    var body: some View {

        Button(action: action) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.black)
                .padding(.vertical, 18)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.4))
                .cornerRadius(35)
                .padding(.horizontal, 25)
        }
    }
}

