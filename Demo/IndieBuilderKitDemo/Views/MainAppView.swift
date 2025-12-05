import SwiftUI
import IndieBuilderKit

struct MainAppView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showSplash = true

    var body: some View {
        ZStack {
            // Main content
            Group {
                if hasCompletedOnboarding {
                    EMIHomeScreen()
                } else {
                    EMIOnboardingView {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                }
            }
            .opacity(showSplash ? 0 : 1)

            // Splash screen overlay
            if showSplash {
                SplashScreen()
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Show splash screen for 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    MainAppView()
}
