//
//  CurrencyConverterScreen.swift
//  IndieBuilderKitDemo
//
//  Currency Converter - Convert between multiple currencies
//

import SwiftUI
import IndieBuilderKit

struct CurrencyConverterScreen: View {
    @State private var amount: String = "1000"
    @State private var fromCurrency: Currency = .INR
    @State private var toCurrency: Currency = .USD
    @State private var convertedAmount: Double = 0
    @State private var showResult = false
    @State private var isLoading = false

    private let currencyService = CurrencyConversionService.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Info Banner
                InfoBanner()

                // Amount Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount")
                        .font(.medium(16))
                        .foregroundColor(.primary)

                    TextField("Enter amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(.regular(20))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                // Currency Selection
                VStack(spacing: 16) {
                    // From Currency
                    CurrencySelector(
                        title: "From",
                        selectedCurrency: $fromCurrency,
                        color: .blue
                    )

                    // Swap button
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            swapCurrencies()
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }

                    // To Currency
                    CurrencySelector(
                        title: "To",
                        selectedCurrency: $toCurrency,
                        color: .green
                    )
                }

                // Convert Button
                PrimaryButton("Convert", style: .default) {
                    convertCurrency()
                }

                // Result Section
                if showResult {
                    ResultCard(
                        amount: Double(amount) ?? 0,
                        fromCurrency: fromCurrency,
                        convertedAmount: convertedAmount,
                        toCurrency: toCurrency
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Exchange Rate Info
                ExchangeRateTable()

                // Disclaimer
                DisclaimerSection()

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .navigationTitle("Currency Converter")
        .navigationBarTitleDisplayMode(.large)
        .overlay {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
            }
        }
    }

    private func convertCurrency() {
        guard let value = Double(amount), value > 0 else {
            return
        }

        isLoading = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            convertedAmount = currencyService.convert(
                amount: value,
                from: fromCurrency.code,
                to: toCurrency.code
            )

            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showResult = true
                isLoading = false
            }

            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }

    private func swapCurrencies() {
        let temp = fromCurrency
        fromCurrency = toCurrency
        toCurrency = temp

        if showResult {
            convertCurrency()
        }
    }
}

// MARK: - Currency Enum

enum Currency: String, CaseIterable, Identifiable {
    case INR = "Indian Rupee"
    case USD = "US Dollar"
    case EUR = "Euro"
    case GBP = "British Pound"
    case JPY = "Japanese Yen"
    case AED = "UAE Dirham"
    case SGD = "Singapore Dollar"
    case CNY = "Chinese Yuan"

    var id: String { rawValue }

    var code: String {
        switch self {
        case .INR: return "INR"
        case .USD: return "USD"
        case .EUR: return "EUR"
        case .GBP: return "GBP"
        case .JPY: return "JPY"
        case .AED: return "AED"
        case .SGD: return "SGD"
        case .CNY: return "CNY"
        }
    }

    var symbol: String {
        switch self {
        case .INR: return "₹"
        case .USD: return "$"
        case .EUR: return "€"
        case .GBP: return "£"
        case .JPY: return "¥"
        case .AED: return "د.إ"
        case .SGD: return "S$"
        case .CNY: return "¥"
        }
    }

    var flag: String {
        switch self {
        case .INR: return "🇮🇳"
        case .USD: return "🇺🇸"
        case .EUR: return "🇪🇺"
        case .GBP: return "🇬🇧"
        case .JPY: return "🇯🇵"
        case .AED: return "🇦🇪"
        case .SGD: return "🇸🇬"
        case .CNY: return "🇨🇳"
        }
    }
}

// MARK: - Info Banner

private struct InfoBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.indigo)

            VStack(alignment: .leading, spacing: 4) {
                Text("Currency Converter")
                    .font(.medium(14))
                    .foregroundColor(.primary)

                Text("Convert between 8 major currencies instantly")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.indigo.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Currency Selector

private struct CurrencySelector: View {
    let title: String
    @Binding var selectedCurrency: Currency
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.medium(14))
                .foregroundColor(.secondary)

            Menu {
                ForEach(Currency.allCases) { currency in
                    Button {
                        selectedCurrency = currency
                    } label: {
                        HStack {
                            Text(currency.flag)
                            Text(currency.rawValue)
                            Text("(\(currency.code))")
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedCurrency.flag)
                        .font(.system(size: 24))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(selectedCurrency.code)
                            .font(.bold(18))
                            .foregroundColor(.primary)

                        Text(selectedCurrency.rawValue)
                            .font(.regular(12))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(color.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Result Card

private struct ResultCard: View {
    let amount: Double
    let fromCurrency: Currency
    let convertedAmount: Double
    let toCurrency: Currency

    var body: some View {
        VStack(spacing: 20) {
            // Conversion display
            VStack(spacing: 12) {
                // From amount
                HStack {
                    Text(fromCurrency.flag)
                        .font(.system(size: 32))

                    Text("\(fromCurrency.symbol)\(EMICalculationService.formatNumber(amount))")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.blue)
                }

                Image(systemName: "arrow.down")
                    .font(.system(size: 24))
                    .foregroundColor(.secondary)

                // To amount
                HStack {
                    Text(toCurrency.flag)
                        .font(.system(size: 32))

                    Text("\(toCurrency.symbol)\(EMICalculationService.formatNumber(convertedAmount))")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.green.opacity(0.1), .blue.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)

            // Exchange rate
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 14))
                        .foregroundColor(.indigo)

                    Text("Exchange Rate")
                        .font(.medium(14))
                        .foregroundColor(.primary)

                    Spacer()
                }

                Text("1 \(fromCurrency.code) = \(String(format: "%.4f", convertedAmount / amount)) \(toCurrency.code)")
                    .font(.regular(13))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.indigo.opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

// MARK: - Exchange Rate Table

private struct ExchangeRateTable: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Popular Exchange Rates")
                    .font(.bold(18))
                Spacer()
            }

            VStack(spacing: 0) {
                ExchangeRateRow(from: "USD", to: "INR", rate: 83.12)
                Divider()
                ExchangeRateRow(from: "EUR", to: "INR", rate: 90.45)
                Divider()
                ExchangeRateRow(from: "GBP", to: "INR", rate: 105.26)
                Divider()
                ExchangeRateRow(from: "AED", to: "INR", rate: 22.63)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
    }
}

private struct ExchangeRateRow: View {
    let from: String
    let to: String
    let rate: Double

    var body: some View {
        HStack {
            Text("1 \(from)")
                .font(.medium(14))
                .foregroundColor(.primary)

            Image(systemName: "arrow.right")
                .font(.system(size: 10))
                .foregroundColor(.secondary)

            Text(to)
                .font(.regular(14))
                .foregroundColor(.secondary)

            Spacer()

            Text(String(format: "%.2f", rate))
                .font(.bold(16))
                .foregroundColor(.blue)
        }
        .padding()
    }
}

// MARK: - Disclaimer Section

private struct DisclaimerSection: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundColor(.orange)

                Text("Disclaimer")
                    .font(.medium(14))
                    .foregroundColor(.primary)

                Spacer()
            }

            Text("Exchange rates are indicative and may vary. Please check with your bank or financial institution for actual rates.")
                .font(.regular(12))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        CurrencyConverterScreen()
    }
}
