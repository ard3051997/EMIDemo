//
//  PPFCalculatorScreen.swift
//  IndieBuilderKitDemo
//
//  PPF (Public Provident Fund) Calculator - Calculate returns on PPF investments
//

import SwiftUI
import IndieBuilderKit

struct PPFCalculatorScreen: View {
    @State private var annualDeposit: String = "150000"
    @State private var interestRate: String = "7.1"
    @State private var investmentYears: String = "15"
    @State private var showResults = false
    @State private var calculation: PPFCalculation?
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Info Banner
                InfoBanner()

                // Input Section
                VStack(spacing: 16) {
                    // Annual Deposit
                    InputSection(title: "Annual Deposit") {
                        CurrencyInput(value: $annualDeposit, placeholder: "Enter annual amount")

                        // Limits info
                        HStack {
                            Text("Min: ₹500")
                                .font(.regular(11))
                                .foregroundColor(.secondary)

                            Spacer()

                            Text("Max: ₹1,50,000")
                                .font(.regular(11))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 4)
                    }

                    // Interest Rate
                    InputSection(title: "Interest Rate (% per annum)") {
                        PercentageInput(value: $interestRate, placeholder: "Enter interest rate")

                        // Current rate info
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 11))
                                .foregroundColor(.blue)

                            Text("Current rate: 7.1% (compounded annually)")
                                .font(.regular(11))
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 4)
                    }

                    // Investment Period
                    InputSection(title: "Investment Period (Years)") {
                        TextField("15", text: $investmentYears)
                            .keyboardType(.numberPad)
                            .font(.regular(16))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                        // Period info
                        HStack {
                            Text("Lock-in: 15 years")
                                .font(.regular(11))
                                .foregroundColor(.secondary)

                            Spacer()

                            Text("Can extend in blocks of 5 years")
                                .font(.regular(11))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 4)
                    }
                }

                // Action Buttons
                HStack(spacing: 12) {
                    PrimaryButton("Calculate", style: .default) {
                        calculatePPF()
                    }

                    SecondaryButton("Reset") {
                        resetForm()
                    }
                    .frame(width: 100)
                }

                // Results Section
                if showResults, let calc = calculation {
                    PPFResultsCard(calculation: calc, onShare: {
                        showShareSheet = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // PPF Benefits
                PPFBenefitsSection()

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .navigationTitle("PPF Calculator")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showShareSheet) {
            if let calc = calculation {
                PPFShareSheet(calculation: calc)
            }
        }
    }

    private func calculatePPF() {
        guard let annual = Double(annualDeposit),
              let rate = Double(interestRate),
              let years = Int(investmentYears) else {
            return
        }

        guard annual >= 500 && annual <= 150000,
              rate > 0 && rate <= 15,
              years >= 15 && years <= 50 else {
            return
        }

        let calc = PPFCalculation(
            annualDeposit: annual,
            interestRate: rate,
            investmentYears: years
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
        annualDeposit = ""
        interestRate = ""
        investmentYears = ""
        showResults = false
        calculation = nil
    }
}

// MARK: - Info Banner

private struct InfoBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "shield.checkered")
                .font(.system(size: 20))
                .foregroundColor(.mint)

            VStack(alignment: .leading, spacing: 4) {
                Text("PPF Calculator")
                    .font(.medium(14))
                    .foregroundColor(.primary)

                Text("Government-backed long-term savings with tax benefits")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.mint.opacity(0.1))
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

// MARK: - PPF Results Card

private struct PPFResultsCard: View {
    let calculation: PPFCalculation
    let onShare: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Maturity Amount - Prominent display
            VStack(spacing: 8) {
                Text("Maturity Amount")
                    .font(.medium(16))
                    .foregroundColor(.secondary)

                Text(EMICalculationService.formatCurrency(calculation.maturityAmount))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.mint)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.mint.opacity(0.1), .mint.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)

            // Visual breakdown with stacked bar representation
            VStack(spacing: 12) {
                // Investment vs Interest visual
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.mint)
                            .frame(width: geometry.size.width * (calculation.investmentPercentage / 100))

                        Rectangle()
                            .fill(Color.yellow)
                            .frame(width: geometry.size.width * (calculation.interestPercentage / 100))
                    }
                }
                .frame(height: 60)
                .cornerRadius(8)

                // Legend
                HStack(spacing: 20) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.mint)
                            .frame(width: 12, height: 12)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total Investment")
                                .font(.regular(11))
                                .foregroundColor(.secondary)

                            Text(EMICalculationService.formatCurrency(calculation.totalInvestment))
                                .font(.bold(14))
                                .foregroundColor(.mint)
                        }
                    }

                    Spacer()

                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 12, height: 12)

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Interest Earned")
                                .font(.regular(11))
                                .foregroundColor(.secondary)

                            Text(EMICalculationService.formatCurrency(calculation.interestEarned))
                                .font(.bold(14))
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Additional Details
            VStack(spacing: 12) {
                ResultRow(
                    title: "Annual Deposit",
                    value: EMICalculationService.formatCurrency(calculation.annualDeposit),
                    color: .mint
                )

                ResultRow(
                    title: "Investment Period",
                    value: "\(calculation.investmentYears) Years",
                    color: .purple
                )

                ResultRow(
                    title: "Interest Rate",
                    value: "\(calculation.interestRate)% p.a.",
                    color: .green
                )

                ResultRow(
                    title: "Wealth Multiplier",
                    value: "\(String(format: "%.2f", calculation.wealthMultiplier))x",
                    color: .orange
                )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Tax Benefits Highlight
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.green)

                    Text("Tax Benefits")
                        .font(.medium(14))
                        .foregroundColor(.primary)

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 6) {
                    TaxBenefitRow(text: "Investment eligible for deduction under Section 80C")
                    TaxBenefitRow(text: "Interest earned is completely tax-free")
                    TaxBenefitRow(text: "Maturity amount is exempt from tax")
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)

            // Growth Insight
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 14))
                        .foregroundColor(.mint)

                    Text("Your Wealth Growth")
                        .font(.medium(14))
                        .foregroundColor(.primary)

                    Spacer()
                }

                Text("With an annual deposit of \(EMICalculationService.formatCurrency(calculation.annualDeposit)) for \(calculation.investmentYears) years at \(calculation.interestRate)% interest, your PPF account will grow to \(EMICalculationService.formatCurrency(calculation.maturityAmount))!")
                    .font(.regular(13))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.mint.opacity(0.1))
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

private struct TaxBenefitRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 10))
                .foregroundColor(.green)
                .padding(.top, 2)

            Text(text)
                .font(.regular(12))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - PPF Benefits Section

private struct PPFBenefitsSection: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Why PPF?")
                    .font(.bold(18))
                Spacer()
            }

            VStack(spacing: 12) {
                BenefitCard(
                    icon: "shield.checkered",
                    title: "Government Backed",
                    description: "100% safe investment backed by Government of India",
                    color: .mint
                )

                BenefitCard(
                    icon: "percent.badge.minus",
                    title: "Tax Benefits",
                    description: "Triple tax benefit - EEE (Exempt-Exempt-Exempt)",
                    color: .green
                )

                BenefitCard(
                    icon: "lock.shield",
                    title: "Long-term Wealth",
                    description: "15-year lock-in ensures disciplined savings",
                    color: .purple
                )

                BenefitCard(
                    icon: "hand.raised.fill",
                    title: "Loan Facility",
                    description: "Loan available from 3rd to 6th year of account",
                    color: .orange
                )

                BenefitCard(
                    icon: "arrow.triangle.pull",
                    title: "Partial Withdrawal",
                    description: "Withdraw after 7 years for specific needs",
                    color: .blue
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

private struct PPFShareSheet: View {
    let calculation: PPFCalculation
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Share your secure")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Text("investment plan!")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 80))
                    .foregroundColor(.mint)

                Text("Inspire others to start their PPF journey for a secure future")
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
            .navigationTitle("Share PPF Plan")
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
        🏛️ My PPF Investment Plan

        Annual Deposit: \(EMICalculationService.formatCurrency(calculation.annualDeposit))
        Interest Rate: \(calculation.interestRate)% p.a.
        Investment Period: \(calculation.investmentYears) Years

        💰 Total Investment: \(EMICalculationService.formatCurrency(calculation.totalInvestment))
        📈 Interest Earned: \(EMICalculationService.formatCurrency(calculation.interestEarned))
        🎯 Maturity Amount: \(EMICalculationService.formatCurrency(calculation.maturityAmount))

        Wealth Growth: \(String(format: "%.2f", calculation.wealthMultiplier))x your investment!

        ✅ Tax benefits under Section 80C
        ✅ Tax-free interest & maturity
        ✅ Government guaranteed

        Start your PPF journey with EMI Calculator App!
        """

        let urlString = "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationView {
        PPFCalculatorScreen()
    }
}
