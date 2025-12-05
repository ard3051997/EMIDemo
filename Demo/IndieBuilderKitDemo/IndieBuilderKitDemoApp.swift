import SwiftUI
import IndieBuilderKit

@main
struct IndieBuilderKitDemoApp: App {
    // Use the real RevenueCat service instead of the demo one
    @State private var subscriptionService = RevenueCatSubscriptionService()
    
    init() {
        // Register custom fonts if needed
    }
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .task {
                    IndieBuilderKit.registerCustomFonts()
                    
                    // Configure RevenueCat with your API Key
                    // TODO: Replace with your actual RevenueCat API Key
                    await subscriptionService.configureAndLoadInitialData(apiKey: "test_bQwtRHTYtGRWHgGhSEulJHtNIcK")
                }
                .environment(\.subscriptionService, subscriptionService)
        }
    }
}
