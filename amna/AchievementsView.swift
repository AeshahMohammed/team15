//
//  AchievementsView.swift
//  team15
//
//  Created by Amna  on 19/06/1447 AH.
//

import SwiftUI

struct AchievementsView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 30) {

            // زر رجوع
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                Spacer()
            }
            .padding(.horizontal)

            Text("إنجازات الطفل")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)

            //  — لاحقًا نربطه ببيانات حقيقية
            VStack(spacing: 20) {
                AchievementCard(title: "إنجازات هذا الأسبوع", progress: 0.8, emoji: "⭐️")
                AchievementCard(title: "إنجازات هذا الشهر", progress: 0.5, emoji: "🌙")
                AchievementCard(title: "عدد المهام المكتملة", progress: 1.0, emoji: "🎉")
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(Color(red: 0.95, green: 0.97, blue: 1.0).ignoresSafeArea())
    }
}

struct AchievementCard: View {
    let title: String
    let progress: Double
    let emoji: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(emoji)
                    .font(.system(size: 36))
                Text(title)
                    .font(.system(size: 22, weight: .semibold))
            }

            ProgressView(value: progress)
                .tint(.blue)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 3)
    }
}

#Preview {
    AchievementsView()
}
