//
//  FeelingFullScreenView.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct FeelingFullScreenView: View {
    @ObservedObject var viewModel: FeelingViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            viewModel.activity.color.opacity(0.15).ignoresSafeArea()
            
            VStack(spacing: 15) {
                
                VStack(spacing: 15) {
                    Text(viewModel.activity.emoji)
                        .font(.system(size: 120))
                    
                    Text(viewModel.activity.name.capitalized)
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
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Add phrase section
                VStack(spacing: 12) {
                    HStack {
                        TextField("Add your own phrase", text: $viewModel.newText)
                            .textFieldStyle(.roundedBorder)
                            .cornerRadius(30)
                        
                        Button("Add") {
                            viewModel.addSentence()
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
                Button("Close") { dismiss() }
                    .font(.system(size: 22, weight: .bold))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(viewModel.activity.color))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
            }
            .padding()
        }
    }
}


