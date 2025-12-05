//
//  EMIOnboardingView.swift
//  IndieBuilderKitDemo
//
//  Custom onboarding flow for EMI Calculator app matching Figma designs
//

import SwiftUI
import IndieBuilderKit

struct EMIOnboardingView: View {
    let onComplete: () -> Void

    var body: some View {
        OnboardingView(
            configuration: OnboardingConfiguration(
                pages: [
                    // Page 1: EMI Calculator Introduction
                    OnboardingPage(
                        content: {
                            EMIOnboardingPage1()
                        },
                        backgroundColor: .blue.opacity(0.03),
                        primaryButtonTitle: "Continue"
                    ),

                    // Page 2: Loan Comparison Feature
                    OnboardingPage(
                        content: {
                            EMIOnboardingPage2()
                        },
                        backgroundColor: .green.opacity(0.03),
                        primaryButtonTitle: "Next"
                    ),

                    // Page 3: Financial News & Features
                    OnboardingPage(
                        content: {
                            EMIOnboardingPage3()
                        },
                        backgroundColor: .purple.opacity(0.03),
                        primaryButtonTitle: "Get Started"
                    )
                ],
                showSkipButton: true,
                showProgressBar: false,
                finalButtonTitle: "Get Started",
                onCompleted: onComplete
            )
        )
    }
}

// MARK: - Page 1: EMI Calculator Introduction

private struct EMIOnboardingPage1: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            // Title
            VStack(spacing: 8) {
                Text("Nurturing Your Dreams, Step")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)

                Text("by Step")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
            }

            Text("Introducing the EMI Calculator! 🚀")
                .font(.system(size: 17))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            // iPhone mockup showing EMI calculator
            PhoneMockupView {
                EMICalculatorPreview()
            }
            .frame(maxHeight: 450)

            // App icon at bottom
            AppIconSmall()
                .scaleEffect(0.8)

            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Page 2: Loan Comparison

private struct EMIOnboardingPage2: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            // Title
            VStack(spacing: 8) {
                Text("Discover Pocket-Friendly")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)

                Text("Loans")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
            }

            HStack(spacing: 4) {
                Text("Instantly Compare Rates with breakdown!")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Text("💸")
                    .font(.system(size: 17))
            }
            .multilineTextAlignment(.center)

            // iPhone mockup showing loan comparison
            PhoneMockupView {
                LoanComparisonPreview()
            }
            .frame(maxHeight: 450)

            // App icon at bottom
            AppIconSmall()
                .scaleEffect(0.8)

            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Page 3: Financial News

private struct EMIOnboardingPage3: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            // Title
            VStack(spacing: 8) {
                Text("Become a Finance Guru")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)

                Text("Stay on Top with Exciting Finance News!")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // iPhone mockup showing news feed
            PhoneMockupView {
                NewsPreview()
            }
            .frame(maxHeight: 450)

            // App icon at bottom
            AppIconSmall()
                .scaleEffect(0.8)

            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Phone Mockup Container

private struct PhoneMockupView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            // Device frame
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.black)

            // Screen content
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white)
                .padding(6)
                .overlay(
                    content()
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .padding(6)
                )

            // Notch
            GeometryReader { geo in
                Capsule()
                    .fill(Color.black)
                    .frame(width: geo.size.width * 0.4, height: 25)
                    .position(x: geo.size.width / 2, y: 12)
            }
        }
        .aspectRatio(0.5, contentMode: .fit)
        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
    }
}

// MARK: - Preview Content

private struct EMICalculatorPreview: View {
    var body: some View {
        VStack(spacing: 16) {
            // Status bar placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 40)

            // Title
            Text("Calculate your EMI")
                .font(.bold(20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            // Tabs
            HStack(spacing: 8) {
                TabChip(title: "EMI", isSelected: true)
                TabChip(title: "Loan Amount", isSelected: false)
                TabChip(title: "Interest", isSelected: false)
                TabChip(title: "Period", isSelected: false)
            }
            .padding(.horizontal)

            // Input fields
            VStack(spacing: 12) {
                InputFieldPreview(label: "Loan Amount", value: "₹500,000")
                InputFieldPreview(label: "Interest Rate", value: "8%")
                InputFieldPreview(label: "Period", value: "5 Year    6 Month")
            }
            .padding(.horizontal)

            // Buttons
            HStack(spacing: 12) {
                Button {} label: {
                    Text("Calculate")
                        .font(.medium(16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.blue)
                        .cornerRadius(12)
                }
                Button {} label: {
                    Text("Reset")
                        .font(.medium(16))
                        .foregroundColor(.blue)
                        .frame(width: 100, height: 50)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}

private struct LoanComparisonPreview: View {
    var body: some View {
        VStack(spacing: 16) {
            // Status bar placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 40)

            // Title
            Text("Compare Loans")
                .font(.bold(20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            // Two columns
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    ComparisonCard(amount: "50000", rate: "12%", duration: "24")
                    ComparisonCard(amount: "50000", rate: "11%", duration: "24")
                }

                // Compare button
                Button {} label: {
                    Text("Compare")
                        .font(.medium(16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.blue)
                        .cornerRadius(12)
                }

                // Results
                VStack(spacing: 8) {
                    Text("Monthly EMI")
                        .font(.medium(14))
                        .foregroundColor(.secondary)

                    HStack {
                        Text("₹2353")
                            .font(.bold(18))
                        Spacer()
                        Text("₹2330")
                            .font(.bold(18))
                    }

                    Text("Difference: 23.23")
                        .font(.regular(14))
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}

private struct NewsPreview: View {
    var body: some View {
        VStack(spacing: 16) {
            // Status bar placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 40)

            // Title
            HStack {
                Text("EMI Calculator")
                    .font(.bold(18))
                Spacer()
                Image(systemName: "bell")
                Image(systemName: "gearshape")
            }
            .padding(.horizontal)

            // News section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("News")
                        .font(.bold(16))
                    Spacer()
                    Text("View More Articles")
                        .font(.regular(12))
                        .foregroundColor(.blue)
                }

                // News cards
                NewsCardPreview()
                NewsCardPreview()
                NewsCardPreview()
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}

// MARK: - Helper Views

private struct TabChip: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.medium(12))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
    }
}

private struct InputFieldPreview: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.regular(12))
                .foregroundColor(.secondary)

            Text(value)
                .font(.regular(16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

private struct ComparisonCard: View {
    let amount: String
    let rate: String
    let duration: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(amount)
                .font(.medium(14))
            Text(rate)
                .font(.regular(12))
            Text(duration)
                .font(.regular(12))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

private struct NewsCardPreview: View {
    var body: some View {
        HStack(spacing: 12) {
            // Image placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text("LAC pullback ends amid buzz...")
                    .font(.regular(12))
                    .lineLimit(2)

                Text("02 June 2023 • Zee News")
                    .font(.regular(10))
                    .foregroundColor(.secondary)

                Text("Read News")
                    .font(.medium(10))
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding(8)
        .background(Color.white)
    }
}

private struct AppIconSmall: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)

            Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                GridRow {
                    QuadrantIconView(icon: "house.fill")
                    QuadrantIconView(icon: "indianrupeesign.circle.fill")
                }
                GridRow {
                    QuadrantIconView(icon: "percent")
                    QuadrantIconView(icon: "list.bullet")
                }
            }
            .frame(width: 40, height: 40)
        }
    }
}

private struct QuadrantIconView: View {
    let icon: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.1))

            Image(systemName: icon)
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: 19, height: 19)
    }
}

#Preview {
    EMIOnboardingView {
        print("Onboarding completed!")
    }
}
