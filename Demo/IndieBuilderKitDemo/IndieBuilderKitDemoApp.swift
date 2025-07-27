import SwiftUI
import IndieBuilderKit

@main
struct IndieBuilderKitDemoApp: App {
    @State private var demoSubscriptionService = DemoSubscriptionService()
    
    init() {
        // Register custom fonts if needed
        
    }
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .task {
                    IndieBuilderKit.registerCustomFonts()
                }
                .environment(\.subscriptionService, demoSubscriptionService)
        }
    }
}
