//
//  SIPCalculatorScreen.swift
//  IndieBuilderKitDemo
//
//  SIP (Systematic Investment Plan) Calculator - Calculate mutual fund returns
//

import SwiftUI
import IndieBuilderKit

struct SIPCalculatorScreen: View {
    @State private var monthlyInvestment: String = "5000"
    @State private var expectedReturnRate: String = "12"
    @State private var investmentYears: String = "10"
    @State private var investmentMonths: String = "0"
    @State private var showResults = false
    @State private var calculation: SIPCalculation?
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Info Banner
                InfoBanner()

                // Input Section
                VStack(spacing: 16) {
                    // Monthly Investment
                    InputSection(title: "Monthly Investment") {
                        CurrencyInput(value: $monthlyInvestment, placeholder: "Enter monthly amount")
                    }

                    // Expected Return Rate
                    InputSection(title: "Expected Annual Return Rate (%)") {
                        PercentageInput(value: $expectedReturnRate, placeholder: "Enter return rate")
                    }

                    // Investment Period
                    InputSection(title: "Investment Period") {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Years")
                                    .font(.regular(12))
                                    .foregroundColor(.secondary)

                                TextField("0", text: $investmentYears)
                                    .keyboardType(.numberPad)
                                    .font(.regular(16))
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Months")
                                    .font(.regular(12))
                                    .foregroundColor(.secondary)

                                TextField("0", text: $investmentMonths)
                                    .keyboardType(.numberPad)
                                    .font(.regular(16))
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }

                // Action Buttons
                HStack(spacing: 12) {
                    PrimaryButton("Calculate", style: .default) {
                        calculateSIP()
                    }

                    SecondaryButton("Reset") {
                        resetForm()
                    }
                    .frame(width: 100)
                }

                // Results Section
                if showResults, let calc = calculation {
                    SIPResultsCard(calculation: calc, onShare: {
                        showShareSheet = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // SIP Benefits
                SIPBenefitsSection()

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .navigationTitle("SIP Calculator")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showShareSheet) {
            if let calc = calculation {
                SIPShareSheet(calculation: calc)
            }
        }
    }

    private func calculateSIP() {
        guard let monthly = Double(monthlyInvestment),
              let rate = Double(expectedReturnRate),
              let years = Int(investmentYears),
              let months = Int(investmentMonths) else {
            return
        }

        let totalMonths = years * 12 + months

        guard monthly >= 500,
              rate > 0 && rate <= 30,
              totalMonths > 0 else {
            return
        }

        let calc = SIPCalculation(
            monthlyInvestment: monthly,
            expectedReturnRate: rate,
            investmentPeriodMonths: totalMonths
        )

        calculation = calc

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showResults = true
        }

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    private func resetForm() {
        monthlyInvestment = ""
        expectedReturnRate = ""
        investmentYears = ""
        investmentMonths = ""
        showResults = false
        calculation = nil
    }
}

// MARK: - Info Banner

private struct InfoBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 20))
                .foregroundColor(.purple)

            VStack(alignment: .leading, spacing: 4) {
                Text("SIP Calculator")
                    .font(.medium(14))
                    .foregroundColor(.primary)

                Text("Calculate wealth creation through regular investments")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Input Section

private struct InputSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.medium(16))
                .foregroundColor(.primary)

            content()
        }
    }
}

// MARK: - Currency Input

private struct CurrencyInput: View {
    @Binding var value: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 8) {
            Text("₹")
                .font(.medium(18))
                .foregroundColor(.secondary)

            TextField(placeholder, text: $value)
                .keyboardType(.numberPad)
                .font(.regular(16))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Percentage Input

private struct PercentageInput: View {
    @Binding var value: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 8) {
            TextField(placeholder, text: $value)
                .keyboardType(.decimalPad)
                .font(.regular(16))

            Text("%")
                .font(.medium(18))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - SIP Results Card

private struct SIPResultsCard: View {
    let calculation: SIPCalculation
    let onShare: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Maturity Value - Prominent display
            VStack(spacing: 8) {
                Text("Maturity Value")
                    .font(.medium(16))
                    .foregroundColor(.secondary)

                Text(EMICalculationService.formatCurrency(calculation.maturityValue))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.purple)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.purple.opacity(0.1), .purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)

            // Visual breakdown with pie chart representation
            HStack(spacing: 16) {
                // Investment vs Returns visual
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: calculation.investmentPercentage / 100)
                            .stroke(Color.blue, lineWidth: 20)
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))

                        Circle()
                            .trim(from: calculation.investmentPercentage / 100, to: 1)
                            .stroke(Color.orange, lineWidth: 20)
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 2) {
                            Text("\(Int(calculation.returnsPercentage))%")
                                .font(.bold(16))
                                .foregroundColor(.primary)
                            Text("Returns")
                                .font(.regular(10))
                                .foregroundColor(.secondary)
                        }
                    }

                    // Legend
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                            Text("Investment")
                                .font(.regular(11))
                                .foregroundColor(.secondary)
                        }
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 8, height: 8)
                            Text("Returns")
                                .font(.regular(11))
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // Breakdown values
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Investment")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text(EMICalculationService.formatCurrency(calculation.totalInvestment))
                            .font(.bold(18))
                            .foregroundColor(.blue)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Estimated Returns")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text(EMICalculationService.formatCurrency(calculation.estimatedReturns))
                            .font(.bold(18))
                            .foregroundColor(.orange)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Wealth Gain")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text("\(Int(calculation.wealthMultiplier))x")
                            .font(.bold(18))
                            .foregroundColor(.purple)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Additional Details
            VStack(spacing: 12) {
                ResultRow(
                    title: "Monthly Investment",
                    value: EMICalculationService.formatCurrency(calculation.monthlyInvestment),
                    color: .blue
                )

                ResultRow(
                    title: "Investment Period",
                    value: "\(calculation.investmentYears) Years, \(calculation.investmentRemainingMonths) Months",
                    color: .purple
                )

                ResultRow(
                    title: "Expected Return",
                    value: "\(calculation.expectedReturnRate)% p.a.",
                    color: .green
                )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Growth Insight
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 14))
                        .foregroundColor(.green)

                    Text("Your Investment Growth")
                        .font(.medium(14))
                        .foregroundColor(.primary)

                    Spacer()
                }

                Text("With a monthly SIP of \(EMICalculationService.formatCurrency(calculation.monthlyInvestment)) for \(calculation.investmentYears) years, your investment will grow to \(EMICalculationService.formatCurrency(calculation.maturityValue))!")
                    .font(.regular(13))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)

            // Share Button
            SecondaryButton("Share via WhatsApp") {
                onShare()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

private struct ResultRow: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)

                Text(title)
                    .font(.regular(14))
                    .foregroundColor(.primary)
            }

            Spacer()

            Text(value)
                .font(.medium(16))
                .foregroundColor(.primary)
        }
    }
}

// MARK: - SIP Benefits Section

private struct SIPBenefitsSection: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Why SIP?")
                    .font(.bold(18))
                Spacer()
            }

            VStack(spacing: 12) {
                BenefitCard(
                    icon: "calendar.badge.clock",
                    title: "Disciplined Investing",
                    description: "Build wealth systematically with regular investments",
                    color: .blue
                )

                BenefitCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Rupee Cost Averaging",
                    description: "Reduce market timing risk with periodic investments",
                    color: .green
                )

                BenefitCard(
                    icon: "sparkles",
                    title: "Power of Compounding",
                    description: "Earn returns on your returns over time",
                    color: .orange
                )

                BenefitCard(
                    icon: "dollarsign.circle",
                    title: "Start Small",
                    description: "Begin your investment journey with just ₹500/month",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(16)
    }
}

private struct BenefitCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.medium(14))
                    .foregroundColor(.primary)

                Text(description)
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Share Sheet

private struct SIPShareSheet: View {
    let calculation: SIPCalculation
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Inspire others to")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Text("build wealth with SIP!")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 80))
                    .foregroundColor(.purple)

                Text("Share your SIP investment plan with friends and family")
                    .font(.regular(16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                PrimaryButton("Share on WhatsApp") {
                    shareOnWhatsApp()
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 40)
            .navigationTitle("Share SIP Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func shareOnWhatsApp() {
        let message = """
        📈 My SIP Investment Plan

        Monthly Investment: \(EMICalculationService.formatCurrency(calculation.monthlyInvestment))
        Expected Return: \(calculation.expectedReturnRate)% p.a.
        Investment Period: \(calculation.investmentYears) Years

        💰 Total Investment: \(EMICalculationService.formatCurrency(calculation.totalInvestment))
        📊 Estimated Returns: \(EMICalculationService.formatCurrency(calculation.estimatedReturns))
        🎯 Maturity Value: \(EMICalculationService.formatCurrency(calculation.maturityValue))

        Wealth Gain: \(Int(calculation.wealthMultiplier))x your investment!

        Start your SIP journey with EMI Calculator App!
        """

        let urlString = "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationView {
        SIPCalculatorScreen()
    }
}
