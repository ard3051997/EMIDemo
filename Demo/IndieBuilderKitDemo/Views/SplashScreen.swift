//
//  SplashScreen.swift
//  IndieBuilderKitDemo
//
//  Splash screen matching Figma design
//

import SwiftUI
import IndieBuilderKit

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var showContent = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // App Icon with animation
                AppIconView()
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.0)

                // App Title
                Text("EMI Calculator")
                    .font(.bold(27))
                    .foregroundColor(.primary)
                    .opacity(showContent ? 1.0 : 0.0)

                Spacer()

                // Tagline section
                VStack(spacing: 16) {
                    Text("Your EMI Companion")
                        .font(.bold(28))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)

                    Text("Unleash Dreams: EMI Calculator Empowers!")
                        .font(.regular(16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1.0 : 0.0)
                .padding(.horizontal, 32)

                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.2)
                    .opacity(showContent ? 1.0 : 0.0)

                Spacer()

                // Trust badge & Made in India
                VStack(spacing: 12) {
                    // Trust badge
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)

                        Text("Trusted by 10M+ users")
                            .font(.body.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)

                    // Made in India badge
                    HStack(spacing: 6) {
                        Text("Made in India")
                            .font(.body)
                            .foregroundColor(.primary)

                        Text("❤️")
                            .font(.body)
                    }
                }
                .opacity(showContent ? 1.0 : 0.0)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            // Animate icon
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }

            // Show content
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.4)) {
                    showContent = true
                }
            }
        }
    }
}

private struct AppIconView: View {
    var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 90, height: 90)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

            // Icon content - 4 quadrants
            Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                GridRow {
                    QuadrantView(icon: "house.fill", color: .white.opacity(0.9))
                    QuadrantView(icon: "indianrupeesign.circle.fill", color: .white.opacity(0.9))
                }
                GridRow {
                    QuadrantView(icon: "percent", color: .white.opacity(0.9))
                    QuadrantView(icon: "list.bullet", color: .white.opacity(0.9))
                }
            }
            .frame(width: 70, height: 70)
        }
    }
}

private struct QuadrantView: View {
    let icon: String
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(color.opacity(0.1))

            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
        }
        .frame(width: 34, height: 34)
    }
}

#Preview {
    SplashScreen()
}
