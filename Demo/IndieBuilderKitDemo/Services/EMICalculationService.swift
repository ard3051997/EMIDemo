//
//  EMICalculationService.swift
//  IndieBuilderKitDemo
//
//  Core calculation logic for all financial tools
//

import Foundation

@Observable
class EMICalculationService {
    // MARK: - Singleton
    static let shared = EMICalculationService()

    // MARK: - Properties
    var calculationHistory: [EMICalculation] = []
    var savedComparisons: [LoanComparison] = []

    private init() {
        loadHistory()
    }

    // MARK: - EMI Calculation

    /// Calculate monthly EMI using the standard formula:
    /// EMI = [P x R x (1+R)^N] / [(1+R)^N-1]
    /// where P = Principal, R = Monthly interest rate, N = Number of months
    static func calculateEMI(
        principal: Double,
        annualRate: Double,
        tenureMonths: Int
    ) -> Double {
        guard principal > 0, annualRate > 0, tenureMonths > 0 else {
            return 0
        }

        let monthlyRate = annualRate / 12 / 100
        let n = Double(tenureMonths)

        let numerator = principal * monthlyRate * pow(1 + monthlyRate, n)
        let denominator = pow(1 + monthlyRate, n) - 1

        return numerator / denominator
    }

    // MARK: - History Management

    func saveCalculation(_ calculation: EMICalculation) {
        calculationHistory.insert(calculation, at: 0)

        // Keep only last 50 calculations
        if calculationHistory.count > 50 {
            calculationHistory.removeLast()
        }

        saveHistory()
    }

    func deleteCalculation(_ calculation: EMICalculation) {
        calculationHistory.removeAll { $0.id == calculation.id }
        saveHistory()
    }

    func clearHistory() {
        calculationHistory.removeAll()
        saveHistory()
    }

    // MARK: - Loan Comparison

    func saveComparison(_ comparison: LoanComparison) {
        savedComparisons.insert(comparison, at: 0)

        // Keep only last 10 comparisons
        if savedComparisons.count > 10 {
            savedComparisons.removeLast()
        }
    }

    // MARK: - Persistence

    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(calculationHistory) {
            UserDefaults.standard.set(encoded, forKey: "emiCalculationHistory")
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "emiCalculationHistory"),
           let decoded = try? JSONDecoder().decode([EMICalculation].self, from: data) {
            calculationHistory = decoded
        }
    }

    // MARK: - Validation

    static func validateLoanAmount(_ amount: Double) -> Bool {
        amount >= 10_000 && amount <= 10_00_00_000
    }

    static func validateInterestRate(_ rate: Double) -> Bool {
        rate >= 1 && rate <= 50
    }

    static func validateTenure(years: Int, months: Int) -> Bool {
        let totalMonths = years * 12 + months
        return totalMonths >= 1 && totalMonths <= 360 // Max 30 years
    }

    // MARK: - Formatting

    static func formatCurrency(_ amount: Double, currencySymbol: String = "₹") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        if let formatted = formatter.string(from: NSNumber(value: amount)) {
            return "\(currencySymbol)\(formatted)"
        }
        return "\(currencySymbol)0"
    }

    static func formatNumber(_ number: Double, decimals: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = 0

        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }

    static func formatPercentage(_ percentage: Double) -> String {
        return String(format: "%.2f%%", percentage)
    }
}

// MARK: - Currency Conversion Service

@Observable
class CurrencyConversionService {
    static let shared = CurrencyConversionService()

    // Mock exchange rates (in production, fetch from API)
    private var exchangeRates: [String: Double] = [
        "INR": 1.0,
        "USD": 0.012,
        "EUR": 0.011,
        "GBP": 0.0095,
        "JPY": 1.80,
        "AED": 0.044,
        "SGD": 0.016,
        "CNY": 0.087
    ]

    private init() {}

    func convert(amount: Double, from: String, to: String) -> Double {
        guard let fromRate = exchangeRates[from],
              let toRate = exchangeRates[to] else {
            return 0
        }

        // Convert to INR first, then to target currency
        let inrAmount = amount / fromRate
        return inrAmount * toRate
    }

    func fetchLatestRates() async throws {
        // In production, implement API call to fetch real-time rates
        // For now, using mock data
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
    }
}
