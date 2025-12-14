//
//  OvalBackButton.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 14/12/2025.
//


import SwiftUI
struct OvalBackButton: View {

    @Environment(\.dismiss) private var dismiss
    @AppStorage("isArabic") private var isArabic = false

    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isArabic ? "chevron.right" : "chevron.left")
                    .foregroundStyle(.primary)
                Text(isArabic ? "رجوع" : "Back")
                    .font(.system(size: 15, weight: .medium))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
        }.buttonStyle(.borderless)
        .controlSize(.mini)
        .buttonStyle(.plain)
        .contentShape(Capsule())

    }
}
