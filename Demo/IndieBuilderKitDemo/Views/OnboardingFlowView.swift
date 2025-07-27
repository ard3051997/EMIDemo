import SwiftUI
import IndieBuilderKit

struct OnboardingFlowView: View {
    var onCompleted: () -> Void
    
    var body: some View {
        OnboardingView(
            configuration: OnboardingConfiguration(
                pages: [
                    // Screen 1: EMI Calculator
                    OnboardingPage(
                        content: {
                            VStack(spacing: 32) {
                                Spacer()
                                
                                Image(systemName: "calculator.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(Color.blue.opacity(0.1))
                                            .frame(width: 160, height: 160)
                                    )
                                
                                VStack(spacing: 16) {
                                    Text("Easy EMI Calculator")
                                        .font(.bold(32))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Calculate your loan EMIs instantly with accuracy. Plan your finances better.")
                                        .font(.regular(18))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                
                                Spacer()
                            }
                        },
                        backgroundColor: .blue.opacity(0.05),
                        primaryButtonTitle: "Next"
                    ),
                    
                    // Screen 2: Analytics
                    OnboardingPage(
                        content: {
                            VStack(spacing: 32) {
                                Spacer()
                                
                                Image(systemName: "chart.pie.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.purple)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(Color.purple.opacity(0.1))
                                            .frame(width: 160, height: 160)
                                    )
                                
                                VStack(spacing: 16) {
                                    Text("Smart Analytics")
                                        .font(.bold(32))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Visualize your payments and interest breakdown with interactive charts.")
                                        .font(.regular(18))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                
                                Spacer()
                            }
                        },
                        backgroundColor: .purple.opacity(0.05),
                        primaryButtonTitle: "Next"
                    ),
                    
                    // Screen 3: Financial Insights
                    OnboardingPage(
                        content: {
                            VStack(spacing: 32) {
                                Spacer()
                                
                                Image(systemName: "newspaper.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.green)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(Color.green.opacity(0.1))
                                            .frame(width: 160, height: 160)
                                    )
                                
                                VStack(spacing: 16) {
                                    Text("Financial Insights")
                                        .font(.bold(32))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Stay updated with the latest financial news and trends to make informed decisions.")
                                        .font(.regular(18))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                
                                Spacer()
                            }
                        },
                        backgroundColor: .green.opacity(0.05)
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
