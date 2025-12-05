//
//  EMIHomeScreen.swift
//  IndieBuilderKitDemo
//
//  Main home screen with all financial tools and conversion funnel
//

import SwiftUI
import IndieBuilderKit

struct EMIHomeScreen: View {
    @Environment(\.subscriptionService) private var subscriptionService
    @State private var showPaywall = false
    @State private var showSettings = false
    @State private var selectedTool: FinancialTool?
    @State private var showPremiumBanner = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Premium banner (conversion funnel optimization)
                    if showPremiumBanner, subscriptionService?.isSubscribed != true {
                        PremiumBannerView(onTap: {
                            showPaywall = true
                        }, onDismiss: {
                            showPremiumBanner = false
                        })
                    }

                    // Quick EMI Calculator Access
                    QuickEMICard()

                    // Compare Loans (with "New" badge)
                    CompareLoanCard()

                    // Financial Tools Section
                    FinancialToolsSection(onToolTap: { tool in
                        handleToolTap(tool)
                    })

                    // Loan Partners Section
                    LoanPartnersSection()

                    // News Section (sample)
                    NewsSection()

                    // Other Apps Cross-Promotion
                    OtherAppsSection()

                    // Share Section
                    ShareAppSection()

                    Spacer(minLength: 40)
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("EMI Calculator")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            if let service = subscriptionService {
                PaywallView(
                    configuration: .emiCalculatorPaywall(),
                    service: service
                )
            }
        }
        .sheet(isPresented: $showSettings) {
            EMISettingsView()
        }
        .sheet(item: $selectedTool) { tool in
            toolDestination(for: tool)
        }
    }

    private func handleToolTap(_ tool: FinancialTool) {
        // Check if premium feature
        if tool.isPremium, subscriptionService?.isSubscribed != true {
            showPaywall = true
        } else {
            selectedTool = tool
        }
    }

    @ViewBuilder
    private func toolDestination(for tool: FinancialTool) -> some View {
        NavigationStack {
            switch tool {
            case .emiCalculator:
                EMICalculatorScreen()
            case .compareLoans:
                LoanComparisonScreen()
            case .fdCalculator:
                FDCalculatorScreen()
            case .sipCalculator:
                SIPCalculatorScreen()
            case .rdCalculator:
                RDCalculatorScreen()
            case .gstCalculator:
                GSTCalculatorScreen()
            case .ppfCalculator:
                PPFCalculatorScreen()
            case .currencyConverter:
                CurrencyConverterScreen()
            default:
                Text("Coming Soon")
                    .font(.bold(20))
            }
        }
    }
}

// MARK: - Premium Banner (Conversion Optimization)

private struct PremiumBannerView: View {
    let onTap: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: "crown.fill")
                .font(.system(size: 20))
                .foregroundColor(.yellow)
                .frame(width: 43, height: 43)
                .background(Color.yellow.opacity(0.2))
                .clipShape(Circle())

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text("Ads-free premium experience at")
                    .font(.regular(14))
                    .foregroundColor(.primary)

                Text("just ₹300/year.")
                    .font(.medium(14))
                    .foregroundColor(.primary)
            }

            Spacer()

            // CTA Button
            Button(action: onTap) {
                Text("Subscribe")
                    .font(.medium(14))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)
            }

            // Dismiss
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Quick EMI Calculator Card

private struct QuickEMICard: View {
    var body: some View {
        NavigationLink {
            EMICalculatorScreen()
        } label: {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: "function")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)

                // Text
                Text("Calculator your EMI")
                    .font(.bold(20))
                    .foregroundColor(.primary)

                Spacer()

                // Arrow
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
            .padding(.horizontal)
        }
    }
}

// MARK: - Compare Loans Card

private struct CompareLoanCard: View {
    var body: some View {
        NavigationLink {
            LoanComparisonScreen()
        } label: {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
                    .frame(width: 40, height: 40)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text("Compare loans")
                        .font(.bold(20))
                        .foregroundColor(.primary)
                }

                // "New" badge
                Text("New")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.yellow)
                    .cornerRadius(4)

                Spacer()

                // Arrow
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
            .padding(.horizontal)
        }
    }
}

// MARK: - Financial Tools Section

private struct FinancialToolsSection: View {
    let onToolTap: (FinancialTool) -> Void
    @State private var showAllTools = false

    private let tools: [FinancialTool] = [
        .fdCalculator, .sipCalculator, .rdCalculator,
        .currencyConverter, .gstCalculator, .ppfCalculator,
        .atmFinder, .bankFinder, .financePlaces
    ]

    var body: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                Text("Financial Tools")
                    .font(.bold(20))

                Spacer()

                Button(showAllTools ? "See less" : "See all") {
                    withAnimation {
                        showAllTools.toggle()
                    }
                }
                .font(.regular(16))
                .foregroundColor(.blue)
            }
            .padding(.horizontal)

            // Tools List
            VStack(spacing: 12) {
                ForEach(showAllTools ? tools : Array(tools.prefix(4))) { tool in
                    FinancialToolRow(tool: tool) {
                        onToolTap(tool)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct FinancialToolRow: View {
    let tool: FinancialTool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: tool.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)

                // Title
                Text(tool.rawValue)
                    .font(.medium(16))
                    .foregroundColor(.primary)

                Spacer()

                // Premium badge or arrow
                if tool.isPremium {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - Other Sections (Simplified)

private struct LoanPartnersSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Loan partners")
                    .font(.bold(18))
                Spacer()
                Text("See all")
                    .font(.regular(14))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3) { _ in
                        LoanPartnerCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

private struct LoanPartnerCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray6))
            .frame(width: 200, height: 100)
            .overlay(
                VStack {
                    Text("Partner Bank")
                        .font(.medium(14))
                    Text("Starting from 8.5%")
                        .font(.regular(12))
                        .foregroundColor(.secondary)
                }
            )
    }
}

private struct NewsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("News")
                    .font(.bold(18))
                Spacer()
                Text("View More Articles")
                    .font(.regular(14))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)

            VStack(spacing: 8) {
                NewsRowPreview()
                NewsRowPreview()
            }
            .padding(.horizontal)
        }
    }
}

private struct NewsRowPreview: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(width: 100, height: 70)

            VStack(alignment: .leading, spacing: 4) {
                Text("Financial news headline...")
                    .font(.regular(14))
                    .lineLimit(2)

                Text("02 June 2023 • Zee News")
                    .font(.regular(12))
                    .foregroundColor(.secondary)

                Text("Read News")
                    .font(.medium(12))
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

private struct OtherAppsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Other Apps")
                    .font(.bold(18))
                Spacer()
                Text("View More Apps")
                    .font(.regular(14))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)

            HStack(spacing: 16) {
                OtherAppCard(name: "EMI\nCalculator")
                OtherAppCard(name: "GST\nCalculator")
                OtherAppCard(name: "Hindi English\nTranslator")
            }
            .padding(.horizontal)
        }
    }
}

private struct OtherAppCard: View {
    let name: String

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 50, height: 50)

            Text(name)
                .font(.regular(12))
                .multilineTextAlignment(.center)
                .frame(height: 40)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ShareAppSection: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Help friends in calculating")
                .font(.bold(20))
                .multilineTextAlignment(.center)

            Text("EMI by sharing.")
                .font(.bold(20))
                .multilineTextAlignment(.center)

            Text("Let your friends and family know about EMI Calculator!")
                .font(.regular(14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            PrimaryButton("Share on WhatsApp") {
                shareApp()
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .padding(.horizontal)
    }

    private func shareApp() {
        let message = "Check out EMI Calculator app! Calculate EMI, compare loans, and more. Download now!"
        let urlString = "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Paywall Configuration Extension

extension PaywallConfiguration {
    static func emiCalculatorPaywall() -> PaywallConfiguration {
        .custom(
            title: "Remove ads and get other Premium benefits",
            subtitle: "Unlock all features and enjoy an ad-free experience",
            image: .systemIcon("crown.fill"),
            iconBackgroundColors: [.yellow, .orange],
            showAnimation: true,
            features: [
                PaywallFeature(iconName: "checkmark.circle.fill", title: "Ads-free experience"),
                PaywallFeature(iconName: "doc.text.fill", title: "Remove watermark from Invoice PDF"),
                PaywallFeature(iconName: "infinity", title: "Create unlimited invoices")
            ]
        )
    }
}

#Preview {
    EMIHomeScreen()
}
