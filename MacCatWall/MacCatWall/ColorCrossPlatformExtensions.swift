//
//  ColorCrossPlatformExtensions.swift
//  Purrticles
//
//  Created by Andy Dent on 15/9/2024.
//

import SwiftUI

extension Color {
    static var systemBackground: Color {
        #if os(iOS)
        return Color(uiColor: .systemBackground)
        #elseif os(macOS)
        return Color(nsColor: .windowBackgroundColor)
        #else
        return Color.white // Fallback color, can be customized
        #endif
    }
    static var secondarySystemBackground: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemBackground)
        #elseif os(macOS)
        return Color(nsColor: .controlBackgroundColor)  //underPageBackgroundColor
        #else
        return Color.gray // Fallback color, can be customized
        #endif
    }
}
