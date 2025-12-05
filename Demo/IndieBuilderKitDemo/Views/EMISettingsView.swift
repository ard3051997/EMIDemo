//
//  EMISettingsView.swift
//  IndieBuilderKitDemo
//
//  Settings screen for EMI Calculator app
//

import SwiftUI
import IndieBuilderKit

struct EMISettingsView: View {
    @Environment(\.subscriptionService) private var subscriptionService
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall = false
    @State private var showClearHistoryAlert = false

    private let calculationService = EMICalculationService.shared

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Subscription Section
                    if let service = subscriptionService {
                        SubscriptionSection(
                            isSubscribed: service.subscriptionStatus.isActive,
                            onManageTap: {
                                // Open subscription management
                                if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                                    UIApplication.shared.open(url)
                                }
                            },
                            onUpgradeTap: {
                                showPaywall = true
                            }
                        )
                    }

                    // App Settings
                    SettingsGroup(title: "App Settings") {
                        SettingsRow(
                            icon: "exclamationmark.circle.fill",
                            title: "Clear Calculation History",
                            subtitle: "\(calculationService.calculationHistory.count) saved",
                            color: .red
                        ) {
                            showClearHistoryAlert = true
                        }

                        SettingsRow(
                            icon: "bell.badge",
                            title: "Notifications",
                            subtitle: "Manage notification preferences",
                            color: .orange
                        ) {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }

                    // Support Section
                    SettingsGroup(title: "Support & Feedback") {
                        SettingsRow(
                            icon: "star.fill",
                            title: "Rate the App",
                            subtitle: "Share your feedback",
                            color: .yellow
                        ) {
                            rateApp()
                        }

                        SettingsRow(
                            icon: "square.and.arrow.up",
                            title: "Share with Friends",
                            subtitle: "Help others discover the app",
                            color: .blue
                        ) {
                            shareApp()
                        }

                        SettingsRow(
                            icon: "envelope.fill",
                            title: "Contact Support",
                            subtitle: "Get help with any issues",
                            color: .cyan
                        ) {
                            contactSupport()
                        }
                    }

                    // Legal Section
                    SettingsGroup(title: "Legal") {
                        SettingsRow(
                            icon: "doc.text",
                            title: "Privacy Policy",
                            subtitle: "How we handle your data",
                            color: .purple
                        ) {
                            openPrivacyPolicy()
                        }

                        SettingsRow(
                            icon: "doc.plaintext",
                            title: "Terms of Service",
                            subtitle: "App usage terms",
                            color: .indigo
                        ) {
                            openTermsOfService()
                        }
                    }

                    // About Section
                    SettingsGroup(title: "About") {
                        AboutSection()
                    }

                    Spacer(minLength: 40)
                }
                .padding(24)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
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
        .alert("Clear History", isPresented: $showClearHistoryAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Clear All", role: .destructive) {
                calculationService.clearHistory()
            }
        } message: {
            Text("This will permanently delete all your saved calculations. This action cannot be undone.")
        }
    }

    private func rateApp() {
        // In production, replace with actual App Store URL
        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review") {
            UIApplication.shared.open(url)
        }
    }

    private func shareApp() {
        let message = "Check out EMI Calculator app! Calculate EMI, compare loans, and more financial tools. Download now!"
        let urlString = "https://apps.apple.com/app/idYOUR_APP_ID"

        let shareText = "\(message)\n\(urlString)"

        if let encoded = shareText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let whatsappURL = URL(string: "whatsapp://send?text=\(encoded)"),
           UIApplication.shared.canOpenURL(whatsappURL) {
            UIApplication.shared.open(whatsappURL)
        } else {
            // Fallback to regular share sheet
            let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let viewController = windowScene.windows.first?.rootViewController {
                viewController.present(activityVC, animated: true)
            }
        }
    }

    private func contactSupport() {
        if let url = URL(string: "mailto:support@example.com?subject=EMI%20Calculator%20Support") {
            UIApplication.shared.open(url)
        }
    }

    private func openPrivacyPolicy() {
        if let url = URL(string: "https://your-website.com/privacy-policy") {
            UIApplication.shared.open(url)
        }
    }

    private func openTermsOfService() {
        if let url = URL(string: "https://your-website.com/terms-of-service") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Subscription Section

private struct SubscriptionSection: View {
    let isSubscribed: Bool
    let onManageTap: () -> Void
    let onUpgradeTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            if isSubscribed {
                // Premium user
                HStack(spacing: 16) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.yellow)
                        .frame(width: 60, height: 60)
                        .background(Color.yellow.opacity(0.2))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Premium Active")
                            .font(.bold(18))
                            .foregroundColor(.primary)

                        Text("Enjoying ad-free experience")
                            .font(.regular(14))
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [.yellow.opacity(0.1), .orange.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)

                SecondaryButton("Manage Subscription") {
                    onManageTap()
                }
            } else {
                // Free user
                HStack(spacing: 16) {
                    Image(systemName: "crown")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                        .frame(width: 60, height: 60)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Upgrade to Premium")
                            .font(.bold(18))
                            .foregroundColor(.primary)

                        Text("Remove ads and unlock features")
                            .font(.regular(14))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .onTapGesture {
                    onUpgradeTap()
                }
            }
        }
    }
}

// MARK: - Settings Group

private struct SettingsGroup<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.bold(18))
                .foregroundColor(.primary)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
    }
}

// MARK: - Settings Row

private struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.1))
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.medium(16))
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.regular(12))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding()
        }

        Divider()
            .padding(.leading, 72)
    }
}

// MARK: - About Section

private struct AboutSection: View {
    var body: some View {
        VStack(spacing: 16) {
            // App Icon
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                    GridRow {
                        QuadrantIconView(icon: "house.fill")
                        QuadrantIconView(icon: "indianrupeesign.circle.fill")
                    }
                    GridRow {
                        QuadrantIconView(icon: "percent")
                        QuadrantIconView(icon: "list.bullet")
                    }
                }
                .frame(width: 60, height: 60)
            }

            VStack(spacing: 8) {
                Text("EMI Calculator")
                    .font(.bold(24))
                    .foregroundColor(.primary)

                Text("Version 1.0.0")
                    .font(.regular(14))
                    .foregroundColor(.secondary)
            }

            // Made in India
            HStack(spacing: 6) {
                Text("Made with")
                    .font(.regular(14))
                    .foregroundColor(.secondary)

                Text("❤️")
                    .font(.regular(14))

                Text("in India")
                    .font(.regular(14))
                    .foregroundColor(.secondary)
            }

            // Feature highlights
            VStack(spacing: 12) {
                Text("Your trusted financial companion")
                    .font(.medium(16))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                HStack(spacing: 20) {
                    FeatureHighlight(icon: "compass.drawing", text: "8 Calculators")
                    FeatureHighlight(icon: "chart.bar", text: "Loan Compare")
                    FeatureHighlight(icon: "dollarsign.circle", text: "Currency")
                }
            }
            .padding(.top, 8)

            // Copyright
            Text("© 2024 EMI Calculator. All rights reserved.")
                .font(.regular(11))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

private struct QuadrantIconView: View {
    let icon: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white.opacity(0.1))

            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: 29, height: 29)
    }
}

private struct FeatureHighlight: View {
    let icon: String
    let text: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)

            Text(text)
                .font(.regular(11))
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    EMISettingsView()
}
