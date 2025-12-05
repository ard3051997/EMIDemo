import SwiftUI
import IndieBuilderKit

struct OnboardingFlowView: View {
    var onCompleted: () -> Void
    
    var body: some View {
        OnboardingView(
            configuration: OnboardingConfiguration(
                pages: [
                    // Page 1
            OnboardingPage(
                content: {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image("onboarding_1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 350)
                        
                        VStack(spacing: 16) {
                            Text("Nurturing Your Dreams,\nStep by Step")
                                .font(.bold(28))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("Introducing the EMI Calculator! 🚀")
                                .font(.regular(18))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                },
                primaryButtonTitle: "Next"
            ),
            
            // Page 2
            OnboardingPage(
                content: {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image("onboarding_2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 350)
                        
                        VStack(spacing: 16) {
                            Text("Discover the Power of\nFinancial Clarity")
                                .font(.bold(28))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("Instantly Compare Rates with breakdown! 💸")
                                .font(.regular(18))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                },
                primaryButtonTitle: "Next"
            ),
            
            // Page 3
            OnboardingPage(
                content: {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image("onboarding_3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 350)
                        
                        VStack(spacing: 16) {
                            Text("Become a Finance Guru")
                                .font(.bold(28))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("Stay on Top with Exciting Finance News!")
                                .font(.regular(18))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                },
                primaryButtonTitle: "Get Started"
            )
                ],
                showSkipButton: true,
                showProgressBar: true,
                finalButtonTitle: "Get Started",
                onCompleted: {
                    onCompleted()
                }
            )
        )
    }
}

#Preview {
    OnboardingFlowView(onCompleted: {})
}
