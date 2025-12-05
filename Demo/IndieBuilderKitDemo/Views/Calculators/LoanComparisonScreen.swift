//
//  LoanComparisonScreen.swift
//  IndieBuilderKitDemo
//
//  Loan Comparison screen - Compare two loans side-by-side
//

import SwiftUI
import IndieBuilderKit

struct LoanComparisonScreen: View {
    @State private var loan1Amount: String = "500000"
    @State private var loan1Rate: String = "12"
    @State private var loan1Duration: String = "24"

    @State private var loan2Amount: String = "500000"
    @State private var loan2Rate: String = "11"
    @State private var loan2Duration: String = "24"

    @State private var comparison: LoanComparison?
    @State private var showResults = false
    @State private var showShareSheet = false
    @Environment(\.subscriptionService) private var subscriptionService

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Compare two loans side-by-side")
                        .font(.regular(16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    Text("Find the best option for you")
                        .font(.medium(14))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)

                // Two loan cards side-by-side
                HStack(alignment: .top, spacing: 12) {
                    // Loan 1
                    LoanInputCard(
                        title: "Loan 1",
                        amount: $loan1Amount,
                        rate: $loan1Rate,
                        duration: $loan1Duration,
                        color: .blue
                    )

                    // Loan 2
                    LoanInputCard(
                        title: "Loan 2",
                        amount: $loan2Amount,
                        rate: $loan2Rate,
                        duration: $loan2Duration,
                        color: .green
                    )
                }
                .padding(.horizontal)

                // Action Buttons
                HStack(spacing: 12) {
                    PrimaryButton("Compare", style: .default) {
                        compareLoans()
                    }

                    SecondaryButton("Reset") {
                        resetForm()
                    }
                    .frame(width: 100)
                }
                .padding(.horizontal)

                // Results Section
                if showResults, let comp = comparison {
                    ComparisonResultsCard(comparison: comp, onShare: {
                        showShareSheet = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Info section
                InfoSection()

                Spacer(minLength: 40)
            }
            .padding(.vertical, 24)
        }
        .navigationTitle("Compare Loans")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showShareSheet) {
            if let comp = comparison {
                ComparisonShareSheet(comparison: comp)
            }
        }
    }

    private func compareLoans() {
        guard let amount1 = Double(loan1Amount),
              let rate1 = Double(loan1Rate),
              let duration1 = Int(loan1Duration),
              let amount2 = Double(loan2Amount),
              let rate2 = Double(loan2Rate),
              let duration2 = Int(loan2Duration) else {
            return
        }

        guard EMICalculationService.validateLoanAmount(amount1),
              EMICalculationService.validateInterestRate(rate1),
              duration1 > 0,
              EMICalculationService.validateLoanAmount(amount2),
              EMICalculationService.validateInterestRate(rate2),
              duration2 > 0 else {
            return
        }

        let loan1 = LoanDetails(
            amount: amount1,
            interestRate: rate1,
            tenureMonths: duration1
        )

        let loan2 = LoanDetails(
            amount: amount2,
            interestRate: rate2,
            tenureMonths: duration2
        )

        let comp = LoanComparison(loan1: loan1, loan2: loan2)
        comparison = comp
        EMICalculationService.shared.saveComparison(comp)

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showResults = true
        }

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    private func resetForm() {
        loan1Amount = ""
        loan1Rate = ""
        loan1Duration = ""
        loan2Amount = ""
        loan2Rate = ""
        loan2Duration = ""
        showResults = false
        comparison = nil
    }
}

// MARK: - Loan Input Card

private struct LoanInputCard: View {
    let title: String
    @Binding var amount: String
    @Binding var rate: String
    @Binding var duration: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)

                Text(title)
                    .font(.bold(18))
                    .foregroundColor(.primary)
            }

            // Loan Amount
            VStack(alignment: .leading, spacing: 6) {
                Text("Amount")
                    .font(.medium(12))
                    .foregroundColor(.secondary)

                HStack(spacing: 6) {
                    Text("₹")
                        .font(.medium(14))
                        .foregroundColor(.secondary)

                    TextField("50000", text: $amount)
                        .keyboardType(.numberPad)
                        .font(.regular(14))
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            // Interest Rate
            VStack(alignment: .leading, spacing: 6) {
                Text("Interest Rate")
                    .font(.medium(12))
                    .foregroundColor(.secondary)

                HStack(spacing: 6) {
                    TextField("12", text: $rate)
                        .keyboardType(.decimalPad)
                        .font(.regular(14))

                    Text("%")
                        .font(.medium(14))
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            // Duration
            VStack(alignment: .leading, spacing: 6) {
                Text("Duration")
                    .font(.medium(12))
                    .foregroundColor(.secondary)

                HStack(spacing: 6) {
                    TextField("24", text: $duration)
                        .keyboardType(.numberPad)
                        .font(.regular(14))

                    Text("months")
                        .font(.medium(14))
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Comparison Results Card

private struct ComparisonResultsCard: View {
    let comparison: LoanComparison
    let onShare: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Comparison Results")
                .font(.bold(20))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Side-by-side EMI comparison
            HStack(spacing: 16) {
                // Loan 1 EMI
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                        Text("Loan 1")
                            .font(.medium(14))
                            .foregroundColor(.secondary)
                    }

                    VStack(spacing: 4) {
                        Text("Monthly EMI")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text(EMICalculationService.formatCurrency(comparison.loan1.monthlyEMI))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(comparison.betterLoanIndex == 1 ? .green : .primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        comparison.betterLoanIndex == 1 ?
                        Color.green.opacity(0.1) :
                        Color(.systemGray6)
                    )
                    .cornerRadius(12)

                    if comparison.betterLoanIndex == 1 {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                            Text("Better")
                                .font(.medium(12))
                                .foregroundColor(.green)
                        }
                    }
                }

                // Loan 2 EMI
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("Loan 2")
                            .font(.medium(14))
                            .foregroundColor(.secondary)
                    }

                    VStack(spacing: 4) {
                        Text("Monthly EMI")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text(EMICalculationService.formatCurrency(comparison.loan2.monthlyEMI))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(comparison.betterLoanIndex == 2 ? .green : .primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        comparison.betterLoanIndex == 2 ?
                        Color.green.opacity(0.1) :
                        Color(.systemGray6)
                    )
                    .cornerRadius(12)

                    if comparison.betterLoanIndex == 2 {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                            Text("Better")
                                .font(.medium(12))
                                .foregroundColor(.green)
                        }
                    }
                }
            }

            // Difference highlight
            VStack(spacing: 8) {
                Text("Difference")
                    .font(.medium(14))
                    .foregroundColor(.secondary)

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("EMI Difference")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text(EMICalculationService.formatCurrency(abs(comparison.differenceEMI)))
                            .font(.bold(18))
                            .foregroundColor(.orange)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Percentage")
                            .font(.regular(12))
                            .foregroundColor(.secondary)

                        Text(String(format: "%.2f%%", comparison.percentageDifference))
                            .font(.bold(18))
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }

            Divider()

            // Detailed breakdown
            VStack(spacing: 16) {
                Text("Detailed Breakdown")
                    .font(.bold(16))
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Loan 1 details
                LoanDetailBreakdown(
                    title: "Loan 1",
                    loan: comparison.loan1,
                    color: .blue
                )

                // Loan 2 details
                LoanDetailBreakdown(
                    title: "Loan 2",
                    loan: comparison.loan2,
                    color: .green
                )
            }

            // Savings summary
            if comparison.betterLoanIndex != 0 {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.yellow)

                        Text("Savings Insight")
                            .font(.bold(16))
                            .foregroundColor(.primary)

                        Spacer()
                    }

                    Text("By choosing Loan \(comparison.betterLoanIndex), you'll save \(EMICalculationService.formatCurrency(abs(comparison.differenceEMI))) per month, totaling \(EMICalculationService.formatCurrency(abs(comparison.totalSavings))) over the loan period!")
                        .font(.regular(14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(12)
            }

            // Share Button
            SecondaryButton("Share Comparison") {
                onShare()
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
        .padding(.horizontal)
    }
}

// MARK: - Loan Detail Breakdown

private struct LoanDetailBreakdown: View {
    let title: String
    let loan: LoanDetails
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)

                Text(title)
                    .font(.medium(16))
                    .foregroundColor(.primary)

                Spacer()
            }

            VStack(spacing: 8) {
                DetailRow(
                    label: "Principal Amount",
                    value: EMICalculationService.formatCurrency(loan.amount)
                )

                DetailRow(
                    label: "Total Interest",
                    value: EMICalculationService.formatCurrency(loan.totalInterest)
                )

                DetailRow(
                    label: "Total Amount",
                    value: EMICalculationService.formatCurrency(loan.totalAmount)
                )

                DetailRow(
                    label: "Tenure",
                    value: "\(loan.tenureYears) Years, \(loan.tenureRemainingMonths) Months"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

private struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.regular(14))
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.medium(14))
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Info Section

private struct InfoSection: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)

                Text("How to compare?")
                    .font(.bold(16))
                    .foregroundColor(.primary)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                InfoPoint(
                    number: "1",
                    text: "Enter loan details for both options"
                )

                InfoPoint(
                    number: "2",
                    text: "Compare interest rates, tenure, and amounts"
                )

                InfoPoint(
                    number: "3",
                    text: "Choose the loan with lower EMI and total cost"
                )
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

private struct InfoPoint: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.bold(14))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.blue)
                .clipShape(Circle())

            Text(text)
                .font(.regular(14))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Share Sheet

private struct ComparisonShareSheet: View {
    let comparison: LoanComparison
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Share your loan comparison")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Text("and help others make better")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Text("financial decisions!")
                    .font(.bold(24))
                    .multilineTextAlignment(.center)

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Text("Share the comparison results with your friends and family via WhatsApp")
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
            .navigationTitle("Share Comparison")
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
        let betterLoan = comparison.betterLoanIndex == 1 ? "Loan 1" : "Loan 2"

        let message = """
        💰 Loan Comparison Results

        📊 Loan 1:
        Amount: \(EMICalculationService.formatCurrency(comparison.loan1.amount))
        Interest: \(comparison.loan1.interestRate)%
        Tenure: \(comparison.loan1.tenureMonths) months
        Monthly EMI: \(EMICalculationService.formatCurrency(comparison.loan1.monthlyEMI))

        📊 Loan 2:
        Amount: \(EMICalculationService.formatCurrency(comparison.loan2.amount))
        Interest: \(comparison.loan2.interestRate)%
        Tenure: \(comparison.loan2.tenureMonths) months
        Monthly EMI: \(EMICalculationService.formatCurrency(comparison.loan2.monthlyEMI))

        💡 \(betterLoan) is better!
        Savings: \(EMICalculationService.formatCurrency(abs(comparison.differenceEMI)))/month
        Total Savings: \(EMICalculationService.formatCurrency(abs(comparison.totalSavings)))

        Calculate and compare loans with EMI Calculator App!
        """

        let urlString = "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationView {
        LoanComparisonScreen()
    }
}
