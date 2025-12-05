//
//  EMIModels.swift
//  IndieBuilderKitDemo
//
//  Data models for EMI Calculator App
//

import Foundation

// MARK: - EMI Calculation Models

struct EMICalculation: Identifiable, Codable {
    let id: UUID
    let loanAmount: Double
    let interestRate: Double
    let tenureMonths: Int
    let monthlyEMI: Double
    let totalInterest: Double
    let totalAmount: Double
    let date: Date

    var tenureYears: Int {
        tenureMonths / 12
    }

    var tenureRemainingMonths: Int {
        tenureMonths % 12
    }

    init(
        id: UUID = UUID(),
        loanAmount: Double,
        interestRate: Double,
        tenureMonths: Int,
        date: Date = Date()
    ) {
        self.id = id
        self.loanAmount = loanAmount
        self.interestRate = interestRate
        self.tenureMonths = tenureMonths
        self.date = date

        // Calculate EMI
        let emi = EMICalculationService.calculateEMI(
            principal: loanAmount,
            annualRate: interestRate,
            tenureMonths: tenureMonths
        )

        self.monthlyEMI = emi
        self.totalAmount = emi * Double(tenureMonths)
        self.totalInterest = totalAmount - loanAmount
    }
}

// MARK: - Loan Comparison Models

struct LoanComparison: Identifiable {
    let id = UUID()
    var loan1: LoanDetails
    var loan2: LoanDetails

    var differenceEMI: Double {
        loan1.monthlyEMI - loan2.monthlyEMI
    }

    var percentageDifference: Double {
        let minEMI = min(loan1.monthlyEMI, loan2.monthlyEMI)
        guard minEMI > 0 else { return 0 }
        return (abs(differenceEMI) / minEMI) * 100
    }

    var betterLoanIndex: Int {
        loan1.totalAmount < loan2.totalAmount ? 1 : 2
    }

    var totalSavings: Double {
        abs((loan1.totalAmount - loan2.totalAmount))
    }
}

struct LoanDetails: Identifiable {
    let id = UUID()
    var amount: Double
    var interestRate: Double
    var tenureMonths: Int

    var tenureYears: Int {
        tenureMonths / 12
    }

    var tenureRemainingMonths: Int {
        tenureMonths % 12
    }

    var monthlyEMI: Double {
        EMICalculationService.calculateEMI(
            principal: amount,
            annualRate: interestRate,
            tenureMonths: tenureMonths
        )
    }

    var totalAmount: Double {
        monthlyEMI * Double(tenureMonths)
    }

    var totalInterest: Double {
        totalAmount - amount
    }

    init(amount: Double = 50000, interestRate: Double = 12, tenureMonths: Int = 24) {
        self.amount = amount
        self.interestRate = interestRate
        self.tenureMonths = tenureMonths
    }
}

// MARK: - Financial Calculator Types

enum FinancialTool: String, CaseIterable, Identifiable {
    case emiCalculator = "EMI Calculator"
    case compareLoans = "Compare Loans"
    case fdCalculator = "FD Calculator"
    case sipCalculator = "SIP Calculator"
    case rdCalculator = "RD Calculator"
    case currencyConverter = "Currency Converter"
    case gstCalculator = "GST Calculator"
    case ppfCalculator = "PPF Calculator"
    case atmFinder = "ATM Finder"
    case bankFinder = "Bank Finder"
    case financePlaces = "Finance Places"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .emiCalculator: return "function"
        case .compareLoans: return "chart.bar.xaxis"
        case .fdCalculator: return "indianrupeesign.circle"
        case .sipCalculator: return "chart.line.uptrend.xyaxis"
        case .rdCalculator: return "arrow.up.forward.circle"
        case .currencyConverter: return "dollarsign.arrow.circlepath"
        case .gstCalculator: return "percent"
        case .ppfCalculator: return "banknote"
        case .atmFinder: return "mappin.and.ellipse"
        case .bankFinder: return "building.columns"
        case .financePlaces: return "map"
        }
    }

    var isPremium: Bool {
        switch self {
        case .atmFinder, .bankFinder, .financePlaces:
            return true
        default:
            return false
        }
    }

    var badge: String? {
        self == .compareLoans ? "New" : nil
    }
}

// MARK: - FD Calculator Models

enum CompoundingFrequency: String, CaseIterable, Identifiable {
    case quarterly = "Quarterly"
    case halfYearly = "Half-Yearly"
    case annually = "Annually"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .quarterly: return "Interest compounded every 3 months"
        case .halfYearly: return "Interest compounded every 6 months"
        case .annually: return "Interest compounded yearly"
        }
    }

    var timesPerYear: Double {
        switch self {
        case .quarterly: return 4
        case .halfYearly: return 2
        case .annually: return 1
        }
    }
}

struct FDCalculation: Identifiable {
    let id = UUID()
    let principalAmount: Double
    let interestRate: Double
    let tenureMonths: Int
    let compoundingFrequency: CompoundingFrequency

    var tenureYears: Int {
        tenureMonths / 12
    }

    var tenureRemainingMonths: Int {
        tenureMonths % 12
    }

    var maturityAmount: Double {
        let rate = interestRate / 100
        let years = Double(tenureMonths) / 12
        let n = compoundingFrequency.timesPerYear
        return principalAmount * pow(1 + rate / n, n * years)
    }

    var interestEarned: Double {
        maturityAmount - principalAmount
    }

    var effectiveRate: Double {
        let rate = interestRate / 100
        let n = compoundingFrequency.timesPerYear
        return (pow(1 + rate / n, n) - 1) * 100
    }
}

// MARK: - SIP Calculator Models

struct SIPCalculation: Identifiable {
    let id = UUID()
    let monthlyInvestment: Double
    let expectedReturnRate: Double
    let investmentPeriodMonths: Int

    var investmentYears: Int {
        investmentPeriodMonths / 12
    }

    var investmentRemainingMonths: Int {
        investmentPeriodMonths % 12
    }

    var totalInvestment: Double {
        monthlyInvestment * Double(investmentPeriodMonths)
    }

    var maturityValue: Double {
        let monthlyRate = expectedReturnRate / 12 / 100
        let n = Double(investmentPeriodMonths)
        let factor = pow(1 + monthlyRate, n) - 1
        return monthlyInvestment * factor / monthlyRate * (1 + monthlyRate)
    }

    var estimatedReturns: Double {
        maturityValue - totalInvestment
    }

    var investmentPercentage: Double {
        guard maturityValue > 0 else { return 0 }
        return (totalInvestment / maturityValue) * 100
    }

    var returnsPercentage: Double {
        guard maturityValue > 0 else { return 0 }
        return (estimatedReturns / maturityValue) * 100
    }

    var wealthMultiplier: Double {
        guard totalInvestment > 0 else { return 0 }
        return maturityValue / totalInvestment
    }
}

// MARK: - RD Calculator Models

struct RDCalculation: Identifiable {
    let id = UUID()
    let monthlyDeposit: Double
    let interestRate: Double
    let tenureMonths: Int

    var tenureYears: Int {
        tenureMonths / 12
    }

    var tenureRemainingMonths: Int {
        tenureMonths % 12
    }

    var totalDeposits: Double {
        monthlyDeposit * Double(tenureMonths)
    }

    var maturityAmount: Double {
        let rate = interestRate / 100 / 12
        let n = Double(tenureMonths)
        return monthlyDeposit * ((pow(1 + rate, n) - 1) / rate) * (1 + rate)
    }

    var interestEarned: Double {
        maturityAmount - totalDeposits
    }

    var investmentPercentage: Double {
        guard maturityAmount > 0 else { return 0 }
        return (totalDeposits / maturityAmount) * 100
    }

    var interestPercentage: Double {
        guard maturityAmount > 0 else { return 0 }
        return (interestEarned / maturityAmount) * 100
    }
}

// MARK: - GST Calculator Models

struct GSTCalculation: Identifiable {
    let id = UUID()
    let amount: Double
    let gstRate: Double
    let isInclusive: Bool

    var baseAmount: Double {
        if isInclusive {
            return amount / (1 + gstRate / 100)
        } else {
            return amount
        }
    }

    var totalGST: Double {
        if isInclusive {
            return amount - baseAmount
        } else {
            return baseAmount * (gstRate / 100)
        }
    }

    var cgst: Double {
        totalGST / 2
    }

    var sgst: Double {
        totalGST / 2
    }

    var totalWithGST: Double {
        if isInclusive {
            return amount
        } else {
            return baseAmount + totalGST
        }
    }
}

// MARK: - PPF Calculator Models

struct PPFCalculation: Identifiable {
    let id = UUID()
    let annualDeposit: Double
    let interestRate: Double
    let investmentYears: Int

    var totalInvestment: Double {
        annualDeposit * Double(investmentYears)
    }

    var maturityAmount: Double {
        let rate = interestRate / 100
        return annualDeposit * ((pow(1 + rate, Double(investmentYears)) - 1) / rate)
    }

    var interestEarned: Double {
        maturityAmount - totalInvestment
    }

    var investmentPercentage: Double {
        guard maturityAmount > 0 else { return 0 }
        return (totalInvestment / maturityAmount) * 100
    }

    var interestPercentage: Double {
        guard maturityAmount > 0 else { return 0 }
        return (interestEarned / maturityAmount) * 100
    }

    var wealthMultiplier: Double {
        guard totalInvestment > 0 else { return 0 }
        return maturityAmount / totalInvestment
    }
}


// MARK: - News Models

struct NewsArticle: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String?
    let imageURL: String?
    let source: String
    let publishedAt: Date
    let url: String

    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        imageURL: String? = nil,
        source: String,
        publishedAt: Date = Date(),
        url: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.source = source
        self.publishedAt = publishedAt
        self.url = url
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: publishedAt)
    }
}

// MARK: - App Settings

struct EMIAppSettings: Codable {
    var defaultCurrency: String = "INR"
    var language: String = "en"
    var enableNotifications: Bool = true
    var hasCompletedOnboarding: Bool = false
    var showPremiumBanner: Bool = true
    var calculationHistory: [String] = [] // Store calculation IDs

    static let shared = EMIAppSettings()
}
