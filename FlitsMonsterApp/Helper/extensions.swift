//
//  File.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 27/09/2024.
//

import Foundation
import SwiftUI

extension Color {
    /// Initialize Color using a hex string, with optional alpha.
    /// Example: `Color(hex: "#FF5733")` or `Color(hex: "#FF5733", alpha: 0.5)`
    init(hex: String, alpha: Double = 1.0) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: Double
        switch hex.count {
        case 6: // RGB (24-bit)
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
        case 8: // ARGB (32-bit)
            r = Double((int >> 24) & 0xFF) / 255.0
            g = Double((int >> 16) & 0xFF) / 255.0
            b = Double((int >> 8) & 0xFF) / 255.0
        default:
            r = 1.0
            g = 1.0
            b = 1.0
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

import SwiftUI

struct RoundedCorners: Shape {
    var radius: CGFloat = 25.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
