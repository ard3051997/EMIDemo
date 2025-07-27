import SwiftUI
import struct SwiftUI.Font

public struct IndieBuilderKit {
    private init() {}
    
    /// Register custom fonts bundled with IndieBuilderKit
    /// Fonts will automatically fallback to system fonts if registration fails
    @available(macOS 10.15, *)
    public static func registerCustomFonts() {
        if #available(macOS 10.15, *) {
            Font.registerFonts()
        } else {
            // Fallback on earlier versions
        };if #available(macOS 10.15, *) {
            Font.registerFonts()
        } else {
            // Fallback on earlier versions
        }
    }
}
