import SwiftUI

// Equivalent of SplashScreen.tsx — shows briefly then pushes to Dashboard
struct SplashView: View {
    @State private var isActive = false
    @State private var opacity  = 0.0
    @State private var scale    = 0.85

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color(hex: "#111827").ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("🏫")
                        .font(.system(size: 72))
                        .scaleEffect(scale)

                    Text("Smart Campus")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("SRM KTR")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
                .opacity(opacity)
                .scaleEffect(scale)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    opacity = 1
                    scale   = 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation { isActive = true }
                }
            }
        }
    }
}