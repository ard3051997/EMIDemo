//
//  FDCalculatorScreen.swift
//  IndieBuilderKitDemo
//
//  Fixed Deposit (FD) Calculator - Calculate maturity amount and interest earned
//

import SwiftUI
import IndieBuilderKit

struct FDCalculatorScreen: View {
    @State private var principalAmount: String = "100000"
    @State private var interestRate: String = "6.5"
    @State private var tenureYears: String = "5"
    @State private var tenureMonths: String = "0"
    @State private var compoundingFrequency: CompoundingFrequency = .quarterly
    @State private var showResults = false
    @State private var calculation: FDCalculation?
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Info Banner
                InfoBanner()

                // Input Section
                VStack(spacing: 16) {
                    // Principal Amount
                    InputSection(title: "Principal Amount") {
                        CurrencyInput(value: $principalAmount, placeholder: "Enter deposit amount")
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

                    // Compounding Frequency
                    InputSection(title: "Compounding Frequency") {
                        VStack(spacing: 8) {
                            ForEach(CompoundingFrequency.allCases) { frequency in
                                CompoundingOption(
                                    frequency: frequency,
                                    isSelected: compoundingFrequency == frequency
                                ) {
                                    compoundingFrequency = frequency
                                }
                            }
                        }
                    }
                }

                // Action Buttons
                HStack(spacing: 12) {
                    PrimaryButton("Calculate", style: .default) {
                        calculateFD()
                    }

                    SecondaryButton("Reset") {
                        resetForm()
                    }
                    .frame(width: 100)
                }

                // Results Section
                if showResults, let calc = calculation {
                    FDResultsCard(calculation: calc, onShare: {
                        showShareSheet = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .navigationTitle("FD Calculator")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showShareSheet) {
            if let calc = calculation {
                FDShareSheet(calculation: calc)
            }
        }
    }

    private func calculateFD() {
        guard let principal = Double(principalAmount),
              let rate = Double(interestRate),
              let years = Int(tenureYears),
              let months = Int(tenureMonths) else {
            return
        }

        let totalMonths = years * 12 + months

        guard principal >= 1000,
              rate > 0 && rate <= 20,
              totalMonths > 0 else {
            return
        }

        let calc = FDCalculation(
            principalAmount: principal,
            interestRate: rate,
            tenureMonths: totalMonths,
            compoundingFrequency: compoundingFrequency
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
        principalAmount = ""
        interestRate = ""
        tenureYears = ""
        tenureMonths = ""
        compoundingFrequency = .quarterly
        showResults = false
        calculation = nil
    }
}

// MARK: - Info Banner

private struct InfoBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text("Fixed Deposit Calculator")
                    .font(.medium(14))
                    .foregroundColor(.primary)

                Text("Calculate maturity amount and interest earned on your FD")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
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

// MARK: - Compounding Option

private struct CompoundingOption: View {
    let frequency: CompoundingFrequency
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(frequency.rawValue)
                        .font(.medium(16))
                        .foregroundColor(.primary)

                    Text(frequency.description)
                        .font(.regular(12))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .blue : .secondary)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - FD Results Card

private struct FDResultsCard: View {
    let calculation: FDCalculation
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
                    .foregroundColor(.green)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.green.opacity(0.1), .green.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)

            // Breakdown
            VStack(spacing: 12) {
                ResultRow(
                    title: "Principal Amount",
                    value: EMICalculationService.formatCurrency(calculation.principalAmount),
                    color: .blue
                )

                ResultRow(
                    title: "Interest Earned",
                    value: EMICalculationService.formatCurrency(calculation.interestEarned),
                    color: .orange
                )

                ResultRow(
                    title: "Maturity Amount",
                    value: EMICalculationService.formatCurrency(calculation.maturityAmount),
                    color: .green
                )

                ResultRow(
                    title: "Tenure",
                    value: "\(calculation.tenureYears) Years, \(calculation.tenureRemainingMonths) Months",
                    color: .purple
                )

                ResultRow(
                    title: "Compounding",
                    value: calculation.compoundingFrequency.rawValue,
                    color: .indigo
                )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Effective Rate Info
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.yellow)

                    Text("Effective Annual Rate")
                        .font(.medium(14))
                        .foregroundColor(.primary)

                    Spacer()

                    Text("\(String(format: "%.2f", calculation.effectiveRate))%")
                        .font(.bold(16))
                        .foregroundColor(.blue)
                }
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

// MARK: - Share Sheet

private struct FDShareSheet: View {
    let calculation: FDCalculation
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Help friends grow")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Text("their wealth with FD!")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 80))
                    .foregroundColor(.green)

                Text("Share your FD calculation results with friends and family")
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
        💰 Fixed Deposit Calculator Results

        Principal Amount: \(EMICalculationService.formatCurrency(calculation.principalAmount))
        Interest Rate: \(calculation.interestRate)% p.a.
        Tenure: \(calculation.tenureYears) Years, \(calculation.tenureRemainingMonths) Months
        Compounding: \(calculation.compoundingFrequency.rawValue)

        Interest Earned: \(EMICalculationService.formatCurrency(calculation.interestEarned))
        Maturity Amount: \(EMICalculationService.formatCurrency(calculation.maturityAmount))

        Effective Rate: \(String(format: "%.2f", calculation.effectiveRate))%

        Calculate your FD returns with EMI Calculator App!
        """

        let urlString = "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationView {
        FDCalculatorScreen()
    }
}
