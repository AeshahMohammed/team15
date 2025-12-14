import SwiftUI

struct FoodPage: View {

    @StateObject private var viewModel = FoodViewModel()
    @AppStorage("isArabic") private var isArabic = false   // ✅ ADD THIS

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    ForEach(viewModel.foodItems) { item in
                        FoodCard(item: item)
                            .onTapGesture {
                                viewModel.selectedItem = item
                            }
                    }
                }
                .padding()
            }
            .navigationTitle(isArabic ? "الطعام" : "Food")
            .toolbar {

                // 🔙 Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    OvalBackButton()
                }

                // 🌍 Language toggle — FIXED (no ViewModel call)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isArabic.toggle()
                        }
                    } label: {
                        Text(isArabic ? "A / ع" : "ع / A")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(14)
                            
                    }
                }
            }
            .sheet(item: $viewModel.selectedItem) { item in
                FoodFullscreen(item: item)
                    .environmentObject(viewModel)
            }
            .environment(
                \.layoutDirection,
                isArabic ? .rightToLeft : .leftToRight
            )
        }
    }
}

#Preview {
    FoodPage()
}
