//
//  RDCalculatorScreen.swift
//  IndieBuilderKitDemo
//
//  RD (Recurring Deposit) Calculator - Calculate maturity amount with monthly deposits
//

import SwiftUI
import IndieBuilderKit

struct RDCalculatorScreen: View {
    @State private var monthlyDeposit: String = "5000"
    @State private var interestRate: String = "6.5"
    @State private var tenureYears: String = "5"
    @State private var tenureMonths: String = "0"
    @State private var showResults = false
    @State private var calculation: RDCalculation?
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Info Banner
                InfoBanner()

                // Input Section
                VStack(spacing: 16) {
                    // Monthly Deposit
                    InputSection(title: "Monthly Deposit") {
                        CurrencyInput(value: $monthlyDeposit, placeholder: "Enter monthly amount")
                    }

                    // Interest Rate
                    InputSection(title: "Interest Rate (% per annum)") {
                        PercentageInput(value: $interestRate, placeholder: "Enter interest rate")
                    }

                    // Tenure
                    InputSection(title: "Deposit Tenure") {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Years")
                                    .font(.regular(12))
                                    .foregroundColor(.secondary)

                                TextField("0", text: $tenureYears)
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

                                TextField("0", text: $tenureMonths)
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
                        calculateRD()
                    }

                    SecondaryButton("Reset") {
                        resetForm()
                    }
                    .frame(width: 100)
                }

                // Results Section
                if showResults, let calc = calculation {
                    RDResultsCard(calculation: calc, onShare: {
                        showShareSheet = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // RD vs FD Comparison
                ComparisonInfoSection()

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .navigationTitle("RD Calculator")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showShareSheet) {
            if let calc = calculation {
                RDShareSheet(calculation: calc)
            }
        }
    }

    private func calculateRD() {
        guard let monthly = Double(monthlyDeposit),
              let rate = Double(interestRate),
              let years = Int(tenureYears),
              let months = Int(tenureMonths) else {
            return
        }

        let totalMonths = years * 12 + months

        guard monthly >= 100,
              rate > 0 && rate <= 20,
              totalMonths > 0 else {
            return
        }

        let calc = RDCalculation(
            monthlyDeposit: monthly,
            interestRate: rate,
            tenureMonths: totalMonths
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
        monthlyDeposit = ""
        interestRate = ""
        tenureYears = ""
        tenureMonths = ""
        showResults = false
        calculation = nil
    }
}

// MARK: - Info Banner

private struct InfoBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "banknote")
                .font(.system(size: 20))
                .foregroundColor(.teal)

            VStack(alignment: .leading, spacing: 4) {
                Text("Recurring Deposit Calculator")
                    .font(.medium(14))
                    .foregroundColor(.primary)

                Text("Save regularly and earn guaranteed returns")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.teal.opacity(0.1))
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

// MARK: - RD Results Card

private struct RDResultsCard: View {
    let calculation: RDCalculation
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
                    .foregroundColor(.teal)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.teal.opacity(0.1), .teal.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)

            // Visual breakdown
            HStack(spacing: 16) {
                // Progress circle
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray5), lineWidth: 20)
                            .frame(width: 100, height: 100)

                        Circle()
                            .trim(from: 0, to: calculation.investmentPercentage / 100)
                            .stroke(Color.teal, lineWidth: 20)
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 2) {
                            Text("\(Int(calculation.interestPercentage))%")
                                .font(.bold(16))
                                .foregroundColor(.primary)
                            Text("Interest")
                                .font(.regular(10))
                                .foregroundColor(.secondary)
                        }
                    }

                    // Legend
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.teal)
                                .frame(width: 8, height: 8)
                            Text("Principal")
                                .font(.regular(11))
                                .foregroundColor(.secondary)
                        }
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 8, height: 8)
                            Text("Interest")
                                .font(.regular(11))
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // Breakdown values
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Deposits")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text(EMICalculationService.formatCurrency(calculation.totalDeposits))
                            .font(.bold(18))
                            .foregroundColor(.teal)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Interest Earned")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text(EMICalculationService.formatCurrency(calculation.interestEarned))
                            .font(.bold(18))
                            .foregroundColor(.orange)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Monthly Deposit")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text(EMICalculationService.formatCurrency(calculation.monthlyDeposit))
                            .font(.bold(18))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Additional Details
            VStack(spacing: 12) {
                ResultRow(
                    title: "Number of Deposits",
                    value: "\(calculation.tenureMonths) months",
                    color: .teal
                )

                ResultRow(
                    title: "Tenure",
                    value: "\(calculation.tenureYears) Years, \(calculation.tenureRemainingMonths) Months",
                    color: .purple
                )

                ResultRow(
                    title: "Interest Rate",
                    value: "\(calculation.interestRate)% p.a.",
                    color: .green
                )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Savings Insight
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.yellow)

                    Text("Savings Insight")
                        .font(.medium(14))
                        .foregroundColor(.primary)

                    Spacer()
                }

                Text("By consistently depositing \(EMICalculationService.formatCurrency(calculation.monthlyDeposit)) monthly for \(calculation.tenureYears) years, you'll accumulate \(EMICalculationService.formatCurrency(calculation.maturityAmount)) at maturity!")
                    .font(.regular(13))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
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

// MARK: - Comparison Info Section

private struct ComparisonInfoSection: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("RD vs FD")
                    .font(.bold(18))
                Spacer()
            }

            VStack(spacing: 12) {
                ComparisonCard(
                    icon: "calendar.badge.plus",
                    title: "Recurring Deposit (RD)",
                    features: [
                        "Monthly deposits",
                        "Disciplined savings",
                        "Flexible amounts",
                        "Compounded interest"
                    ],
                    color: .teal
                )

                ComparisonCard(
                    icon: "banknote.fill",
                    title: "Fixed Deposit (FD)",
                    features: [
                        "One-time deposit",
                        "Lump sum investment",
                        "Higher interest rates",
                        "Best for large amounts"
                    ],
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(16)
    }
}

private struct ComparisonCard: View {
    let icon: String
    let title: String
    let features: [String]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.1))
                    .cornerRadius(10)

                Text(title)
                    .font(.medium(16))
                    .foregroundColor(.primary)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 6) {
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(color)

                        Text(feature)
                            .font(.regular(13))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Share Sheet

private struct RDShareSheet: View {
    let calculation: RDCalculation
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Share your disciplined")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Text("savings plan!")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 80))
                    .foregroundColor(.teal)

                Text("Inspire friends and family to start their RD journey")
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
            .navigationTitle("Share RD Plan")
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
        💰 My Recurring Deposit Plan

        Monthly Deposit: \(EMICalculationService.formatCurrency(calculation.monthlyDeposit))
        Interest Rate: \(calculation.interestRate)% p.a.
        Tenure: \(calculation.tenureYears) Years

        💵 Total Deposits: \(EMICalculationService.formatCurrency(calculation.totalDeposits))
        📈 Interest Earned: \(EMICalculationService.formatCurrency(calculation.interestEarned))
        🎯 Maturity Amount: \(EMICalculationService.formatCurrency(calculation.maturityAmount))

        Start your disciplined savings journey with EMI Calculator App!
        """

        let urlString = "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationView {
        RDCalculatorScreen()
    }
}
