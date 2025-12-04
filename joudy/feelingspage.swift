//
//  feelingspage.swift
//  team15
//
//  Created by aeshah mohammed alabdulkarim on 04/12/2025.
//


import SwiftUI

struct feelingspage: View {
    
    private let feelings: [Feeling] = [
        Feeling(name: "happy", emoji: "😄", color: .yellow),
        Feeling(name: "sad", emoji: "☹️", color: .blue),
        Feeling(name: "scared", emoji: "😨", color: .purple),
        Feeling(name: "angry", emoji: "😡", color: .red),
        Feeling(name: "excited", emoji: "😆", color: .orange),
        Feeling(name: "shy", emoji: "☺️", color: .pink),
        Feeling(name: "tierd", emoji: "🫩", color: .teal),
        Feeling(name: "proud", emoji: "😌", color: .blue),
        Feeling(name: "bored", emoji: "🥱", color: .green),
        Feeling(name: "surpraise", emoji: "😲", color: .mint)
    ]
    
    @State private var selectedFeeling: Feeling? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 22) {
                        ForEach(feelings) { feeling in
                            FeelingBigCard(activity: feeling)
                                .onTapGesture {
                                    selectedFeeling = feeling
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Feelings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedFeeling) { feeling in
                FeelingFullScreenView(viewModel: FeelingViewModel(activity: feeling))
            }
        }
    }
}