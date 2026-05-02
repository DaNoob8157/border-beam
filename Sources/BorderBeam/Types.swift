import SwiftUI

// MARK: - Public Types

/// Size/type preset for the border beam effect.
public enum BorderBeamSize: String, Sendable {
    /// Small button-sized element with compact glow.
    case sm
    /// Medium card-sized element with full border glow (default).
    case md
    /// Bottom-only traveling glow for search bars and inputs.
    case line
}

/// Color palette for the beam effect.
public enum BorderBeamColorVariant: String, Sendable {
    /// Full rainbow spectrum (default).
    case colorful
    /// Monochromatic grayscale.
    case mono
    /// Blue and purple tones.
    case ocean
    /// Warm orange, yellow, and red tones.
    case sunset
}

/// Theme mode for adapting beam colors to the background.
public enum BorderBeamTheme: String, Sendable {
    /// Optimized for dark backgrounds (default).
    case dark
    /// Optimized for light backgrounds.
    case light
    /// Automatically follows the system color scheme.
    case auto
}

// MARK: - Internal helpers

/// A color stored as normalized (0–1) RGB components so it can be used in both
/// SwiftUI and Core Graphics contexts without UIKit/AppKit dependencies.
struct BeamColor: Sendable {
    let r: CGFloat
    let g: CGFloat
    let b: CGFloat

    /// Initialize from 0–255 integer components.
    init(_ r: Int, _ g: Int, _ b: Int) {
        self.r = CGFloat(r) / 255
        self.g = CGFloat(g) / 255
        self.b = CGFloat(b) / 255
    }

    func swiftUIColor(opacity: Double = 1) -> Color {
        Color(red: Double(r), green: Double(g), blue: Double(b), opacity: opacity)
    }

    func cgColor(alpha: CGFloat = 1) -> CGColor {
        CGColor(red: r, green: g, blue: b, alpha: alpha)
    }
}

/// A colored blob used by the `line` variant, positioned relative to the beam center.
struct LineBeamColor: Sendable {
    let color: BeamColor
    let sizeW: CGFloat   // half-width of the ellipse in points
    let sizeH: CGFloat   // half-height of the ellipse in points
    let offsetX: CGFloat // horizontal offset from the beam position in points
    let offsetY: CGFloat // vertical offset from the bottom edge in points
}
