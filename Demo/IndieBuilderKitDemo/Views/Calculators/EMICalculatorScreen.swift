//
//  EMICalculatorScreen.swift
//  IndieBuilderKitDemo
//
//  Main EMI Calculator screen
//

import SwiftUI
import IndieBuilderKit

struct EMICalculatorScreen: View {
    @State private var loanAmount: String = "500000"
    @State private var interestRate: String = "8.5"
    @State private var tenureYears: String = "5"
    @State private var tenureMonths: String = "0"
    @State private var showResults = false
    @State private var calculation: EMICalculation?
    @State private var showShareSheet = false
    @Environment(\.subscriptionService) private var subscriptionService

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Input Section
                VStack(spacing: 16) {
                    // Loan Amount
                    InputSection(title: "Loan Amount") {
                        CurrencyInput(value: $loanAmount, placeholder: "Enter loan amount")
                    }

                    // Interest Rate
                    InputSection(title: "Interest Rate (% per annum)") {
                        PercentageInput(value: $interestRate, placeholder: "Enter interest rate")
                    }

                    // Tenure
                    InputSection(title: "Loan Tenure") {
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
                        calculateEMI()
                    }

                    SecondaryButton("Reset") {
                        resetForm()
                    }
                    .frame(width: 100)
                }

                // Results Section
                if showResults, let calc = calculation {
                    ResultsCard(calculation: calc, onShare: {
                        showShareSheet = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .navigationTitle("EMI Calculator")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showShareSheet) {
            if let calc = calculation {
                ShareSheet(calculation: calc)
            }
        }
    }

    private func calculateEMI() {
        guard let amount = Double(loanAmount),
              let rate = Double(interestRate),
              let years = Int(tenureYears),
              let months = Int(tenureMonths) else {
            return
        }

        let totalMonths = years * 12 + months

        guard EMICalculationService.validateLoanAmount(amount),
              EMICalculationService.validateInterestRate(rate),
              totalMonths > 0 else {
            return
        }

        let calc = EMICalculation(
            loanAmount: amount,
            interestRate: rate,
            tenureMonths: totalMonths
        )

        calculation = calc
        EMICalculationService.shared.saveCalculation(calc)

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showResults = true
        }

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    private func resetForm() {
        loanAmount = ""
        interestRate = ""
        tenureYears = ""
        tenureMonths = ""
        showResults = false
        calculation = nil
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

// MARK: - Results Card

private struct ResultsCard: View {
    let calculation: EMICalculation
    let onShare: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Monthly EMI - Prominent display
            VStack(spacing: 8) {
                Text("Monthly EMI")
                    .font(.medium(16))
                    .foregroundColor(.secondary)

                Text(EMICalculationService.formatCurrency(calculation.monthlyEMI))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.blue)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.blue.opacity(0.1), .blue.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)

            // Breakdown
            VStack(spacing: 12) {
                ResultRow(
                    title: "Principal Amount",
                    value: EMICalculationService.formatCurrency(calculation.loanAmount),
                    color: .blue
                )

                ResultRow(
                    title: "Total Interest",
                    value: EMICalculationService.formatCurrency(calculation.totalInterest),
                    color: .orange
                )

                ResultRow(
                    title: "Total Amount",
                    value: EMICalculationService.formatCurrency(calculation.totalAmount),
                    color: .green
                )

                ResultRow(
                    title: "Tenure",
                    value: "\(calculation.tenureYears) Years, \(calculation.tenureRemainingMonths) Months",
                    color: .purple
                )
            }
            .padding()
            .background(Color(.systemGray6))
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

// MARK: - Share Sheet

private struct ShareSheet: View {
    let calculation: EMICalculation
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Help friends in calculating")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Text("EMI by sharing.")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Text("Let your friends and family know about EMI Calculator!")
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
            .navigationTitle("Share Results")
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
        💰 EMI Calculator Results
        Loan Amount: \(EMICalculationService.formatCurrency(calculation.loanAmount))
        Interest Rate: \(calculation.interestRate)%
        Tenure: \(calculation.tenureYears) Years, \(calculation.tenureRemainingMonths) Months
        Monthly EMI: \(EMICalculationService.formatCurrency(calculation.monthlyEMI))

        Total Interest: \(EMICalculationService.formatCurrency(calculation.totalInterest))
        Total Amount: \(EMICalculationService.formatCurrency(calculation.totalAmount))

        Download EMI Calculator App!
        """

        let urlString = "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationView {
        EMICalculatorScreen()
    }
}
