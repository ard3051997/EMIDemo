import SwiftUI
import IndieBuilderKit

struct MainAppView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                EMICalculatorView()
            } else {
                OnboardingFlowView {
                    withAnimation {
                        hasCompletedOnboarding = true
                    }
                }
            }
        }
    }
}

#Preview {
    MainAppView()
}
