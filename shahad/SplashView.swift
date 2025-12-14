import SwiftUI

struct SplashView: View {

    @StateObject private var vm = SplashViewModel()
    @Binding var didFinishSplash: Bool

    var body: some View {
        ZStack {

            // ✅ WHITE BACKGROUND
            Color.white
                .ignoresSafeArea()

            Image("taifpic")
                .resizable()
                .scaledToFit()
                .frame(width: 240)
                .offset(
                    x: vm.animate ? -220 : 200,
                    y: vm.animate ? -500 : 380
                )
                .opacity(vm.animate ? 1 : 0)
        }
        .onAppear {
            vm.startAnimation()
        }
        .onChange(of: vm.goHome) { _, newValue in
            if newValue {
                didFinishSplash = true
            }
        }
    }
}
