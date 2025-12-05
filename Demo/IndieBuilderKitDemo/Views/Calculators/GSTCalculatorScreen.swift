//
//  GSTCalculatorScreen.swift
//  IndieBuilderKitDemo
//
//  GST Calculator - Add or remove GST from amounts
//

import SwiftUI
import IndieBuilderKit

struct GSTCalculatorScreen: View {
    @State private var amount: String = "10000"
    @State private var gstRate: GSTRate = .eighteen
    @State private var calculationType: CalculationType = .exclusive
    @State private var showResults = false
    @State private var calculation: GSTCalculation?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Info Banner
                InfoBanner()

                // Calculation Type Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Calculation Type")
                        .font(.medium(16))
                        .foregroundColor(.primary)

                    HStack(spacing: 12) {
                        CalculationTypeButton(
                            type: .exclusive,
                            isSelected: calculationType == .exclusive
                        ) {
                            calculationType = .exclusive
                            if showResults {
                                calculateGST()
                            }
                        }

                        CalculationTypeButton(
                            type: .inclusive,
                            isSelected: calculationType == .inclusive
                        ) {
                            calculationType = .inclusive
                            if showResults {
                                calculateGST()
                            }
                        }
                    }
                }

                // Input Section
                VStack(spacing: 16) {
                    // Amount
                    InputSection(
                        title: calculationType == .exclusive ? "Amount (excluding GST)" : "Amount (including GST)"
                    ) {
                        CurrencyInput(value: $amount, placeholder: "Enter amount")
                    }

                    // GST Rate Selector
                    InputSection(title: "GST Rate") {
                        VStack(spacing: 8) {
                            ForEach(GSTRate.allCases) { rate in
                                GSTRateOption(
                                    rate: rate,
                                    isSelected: gstRate == rate
                                ) {
                                    gstRate = rate
                                    if showResults {
                                        calculateGST()
                                    }
                                }
                            }
                        }
                    }
                }

                // Action Buttons
                HStack(spacing: 12) {
                    PrimaryButton("Calculate", style: .default) {
                        calculateGST()
                    }

                    SecondaryButton("Reset") {
                        resetForm()
                    }
                    .frame(width: 100)
                }

                // Results Section
                if showResults, let calc = calculation {
                    GSTResultsCard(
                        calculation: calc,
                        calculationType: calculationType
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // GST Rates Info
                GSTRatesInfoSection()

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .navigationTitle("GST Calculator")
        .navigationBarTitleDisplayMode(.large)
    }

    private func calculateGST() {
        guard let value = Double(amount), value > 0 else {
            return
        }

        let calc = GSTCalculation(
            amount: value,
            gstRate: gstRate.value,
            isInclusive: calculationType == .inclusive
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
        amount = ""
        gstRate = .eighteen
        calculationType = .exclusive
        showResults = false
        calculation = nil
    }
}

// MARK: - Calculation Type

enum CalculationType {
    case exclusive // Add GST
    case inclusive // Remove GST

    var title: String {
        switch self {
        case .exclusive: return "Add GST"
        case .inclusive: return "Remove GST"
        }
    }

    var icon: String {
        switch self {
        case .exclusive: return "plus.circle.fill"
        case .inclusive: return "minus.circle.fill"
        }
    }

    var description: String {
        switch self {
        case .exclusive: return "Calculate final amount with GST"
        case .inclusive: return "Extract GST from total amount"
        }
    }
}

// MARK: - GST Rate

enum GSTRate: Double, CaseIterable, Identifiable {
    case zero = 0
    case five = 5
    case twelve = 12
    case eighteen = 18
    case twentyEight = 28

    var id: Double { rawValue }

    var value: Double { rawValue }

    var displayText: String {
        "\(Int(rawValue))% GST"
    }

    var description: String {
        switch self {
        case .zero: return "Essential goods (grains, fresh vegetables)"
        case .five: return "Common goods (sugar, tea, edible oil)"
        case .twelve: return "Processed food, electronics accessories"
        case .eighteen: return "Most services, electronics, hotels"
        case .twentyEight: return "Luxury goods, automobiles"
        }
    }
}

// MARK: - Info Banner

private struct InfoBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "percent")
                .font(.system(size: 20))
                .foregroundColor(.cyan)

            VStack(alignment: .leading, spacing: 4) {
                Text("GST Calculator")
                    .font(.medium(14))
                    .foregroundColor(.primary)

                Text("Calculate GST for your business transactions")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.cyan.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Calculation Type Button

private struct CalculationTypeButton: View {
    let type: CalculationType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: type.icon)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .white : .cyan)

                VStack(spacing: 4) {
                    Text(type.title)
                        .font(.medium(16))
                        .foregroundColor(isSelected ? .white : .primary)

                    Text(type.description)
                        .font(.regular(11))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(isSelected ? Color.cyan : Color.cyan.opacity(0.1))
            .cornerRadius(16)
        }
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
                .keyboardType(.decimalPad)
                .font(.regular(16))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - GST Rate Option

private struct GSTRateOption: View {
    let rate: GSTRate
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(rate.displayText)
                        .font(.medium(16))
                        .foregroundColor(.primary)

                    Text(rate.description)
                        .font(.regular(12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .cyan : .secondary)
            }
            .padding()
            .background(isSelected ? Color.cyan.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - GST Results Card

private struct GSTResultsCard: View {
    let calculation: GSTCalculation
    let calculationType: CalculationType

    var body: some View {
        VStack(spacing: 20) {
            // Final Amount - Prominent display
            VStack(spacing: 8) {
                Text(calculationType == .exclusive ? "Final Amount" : "Base Amount")
                    .font(.medium(16))
                    .foregroundColor(.secondary)

                Text(EMICalculationService.formatCurrency(
                    calculationType == .exclusive ? calculation.totalWithGST : calculation.baseAmount
                ))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.cyan)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.cyan.opacity(0.1), .cyan.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)

            // Breakdown
            VStack(spacing: 12) {
                if calculationType == .exclusive {
                    ResultRow(
                        title: "Base Amount",
                        value: EMICalculationService.formatCurrency(calculation.baseAmount),
                        color: .blue
                    )

                    ResultRow(
                        title: "CGST (\(calculation.gstRate / 2)%)",
                        value: EMICalculationService.formatCurrency(calculation.cgst),
                        color: .orange
                    )

                    ResultRow(
                        title: "SGST (\(calculation.gstRate / 2)%)",
                        value: EMICalculationService.formatCurrency(calculation.sgst),
                        color: .orange
                    )

                    ResultRow(
                        title: "Total GST (\(calculation.gstRate)%)",
                        value: EMICalculationService.formatCurrency(calculation.totalGST),
                        color: .red
                    )

                    ResultRow(
                        title: "Final Amount",
                        value: EMICalculationService.formatCurrency(calculation.totalWithGST),
                        color: .cyan
                    )
                } else {
                    ResultRow(
                        title: "Total Amount",
                        value: EMICalculationService.formatCurrency(calculation.totalWithGST),
                        color: .cyan
                    )

                    ResultRow(
                        title: "Total GST (\(calculation.gstRate)%)",
                        value: EMICalculationService.formatCurrency(calculation.totalGST),
                        color: .red
                    )

                    ResultRow(
                        title: "CGST (\(calculation.gstRate / 2)%)",
                        value: EMICalculationService.formatCurrency(calculation.cgst),
                        color: .orange
                    )

                    ResultRow(
                        title: "SGST (\(calculation.gstRate / 2)%)",
                        value: EMICalculationService.formatCurrency(calculation.sgst),
                        color: .orange
                    )

                    ResultRow(
                        title: "Base Amount",
                        value: EMICalculationService.formatCurrency(calculation.baseAmount),
                        color: .blue
                    )
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Formula explanation
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "function")
                        .font(.system(size: 14))
                        .foregroundColor(.purple)

                    Text("How it's calculated")
                        .font(.medium(14))
                        .foregroundColor(.primary)

                    Spacer()
                }

                if calculationType == .exclusive {
                    Text("GST Amount = Base Amount × (GST Rate / 100)\nFinal Amount = Base Amount + GST Amount")
                        .font(.regular(13))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Base Amount = Total Amount / (1 + GST Rate / 100)\nGST Amount = Total Amount - Base Amount")
                        .font(.regular(13))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(12)
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

// MARK: - GST Rates Info Section

private struct GSTRatesInfoSection: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("GST Rate Slabs in India")
                    .font(.bold(18))
                Spacer()
            }

            VStack(spacing: 12) {
                ForEach(GSTRate.allCases) { rate in
                    GSTRateInfoCard(rate: rate)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(16)
    }
}

private struct GSTRateInfoCard: View {
    let rate: GSTRate

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Rate badge
            Text("\(Int(rate.value))%")
                .font(.bold(18))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(
                            rate.value == 0 ? Color.green :
                            rate.value == 5 ? Color.blue :
                            rate.value == 12 ? Color.orange :
                            rate.value == 18 ? Color.purple :
                            Color.red
                        )
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(rate.displayText)
                    .font(.medium(14))
                    .foregroundColor(.primary)

                Text(rate.description)
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

#Preview {
    NavigationView {
        GSTCalculatorScreen()
    }
}
