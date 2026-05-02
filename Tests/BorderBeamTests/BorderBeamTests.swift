import Testing
@testable import BorderBeam

// MARK: - BorderBeamSize

@Suite("BorderBeamSize")
struct BorderBeamSizeTests {

    @Test("All cases are present")
    func allCases() {
        let cases: [BorderBeamSize] = [.sm, .md, .line]
        #expect(cases.count == 3)
    }

    @Test("Raw values match expected strings")
    func rawValues() {
        #expect(BorderBeamSize.sm.rawValue   == "sm")
        #expect(BorderBeamSize.md.rawValue   == "md")
        #expect(BorderBeamSize.line.rawValue == "line")
    }
}

// MARK: - BorderBeamColorVariant

@Suite("BorderBeamColorVariant")
struct BorderBeamColorVariantTests {

    @Test("All cases are present")
    func allCases() {
        let cases: [BorderBeamColorVariant] = [.colorful, .mono, .ocean, .sunset]
        #expect(cases.count == 4)
    }

    @Test("Raw values match expected strings")
    func rawValues() {
        #expect(BorderBeamColorVariant.colorful.rawValue == "colorful")
        #expect(BorderBeamColorVariant.mono.rawValue     == "mono")
        #expect(BorderBeamColorVariant.ocean.rawValue    == "ocean")
        #expect(BorderBeamColorVariant.sunset.rawValue   == "sunset")
    }
}

// MARK: - BorderBeamTheme

@Suite("BorderBeamTheme")
struct BorderBeamThemeTests {

    @Test("All cases are present")
    func allCases() {
        let cases: [BorderBeamTheme] = [.dark, .light, .auto]
        #expect(cases.count == 3)
    }

    @Test("Raw values match expected strings")
    func rawValues() {
        #expect(BorderBeamTheme.dark.rawValue  == "dark")
        #expect(BorderBeamTheme.light.rawValue == "light")
        #expect(BorderBeamTheme.auto.rawValue  == "auto")
    }
}

// MARK: - BeamColor

@Suite("BeamColor")
struct BeamColorTests {

    @Test("Integer initializer normalizes to 0–1 range")
    func normalizedComponents() {
        let color = BeamColor(255, 128, 0)
        #expect(color.r == 1.0)
        #expect(abs(Double(color.g) - (128.0 / 255.0)) < 1e-6)
        #expect(color.b == 0.0)
    }

    @Test("Black color initializes to zero components")
    func blackColor() {
        let black = BeamColor(0, 0, 0)
        #expect(black.r == 0)
        #expect(black.g == 0)
        #expect(black.b == 0)
    }

    @Test("White color initializes to unit components")
    func whiteColor() {
        let white = BeamColor(255, 255, 255)
        #expect(white.r == 1)
        #expect(white.g == 1)
        #expect(white.b == 1)
    }

    @Test("cgColor alpha is applied correctly")
    func cgColorAlpha() {
        let color = BeamColor(255, 0, 0)
        let cg = color.cgColor(alpha: 0.5)
        // CGColor components: [R, G, B, A] in device RGB
        let comps = cg.components ?? []
        #expect(comps.count >= 4)
        #expect(abs(Double(comps[3]) - 0.5) < 1e-6)
    }
}

// MARK: - BeamColorPalettes

@Suite("BeamColorPalettes")
struct BeamColorPalettesTests {

    @Test("borderColors returns non-empty array for all variants and themes",
          arguments: [
            (BorderBeamColorVariant.colorful, true),
            (BorderBeamColorVariant.colorful, false),
            (BorderBeamColorVariant.mono,     true),
            (BorderBeamColorVariant.mono,     false),
            (BorderBeamColorVariant.ocean,    true),
            (BorderBeamColorVariant.ocean,    false),
            (BorderBeamColorVariant.sunset,   true),
            (BorderBeamColorVariant.sunset,   false),
          ])
    func borderColorsNonEmpty(variant: BorderBeamColorVariant, isDark: Bool) {
        let colors = BeamColorPalettes.borderColors(for: variant, isDark: isDark)
        #expect(!colors.isEmpty)
    }

    @Test("lineColors returns non-empty array for all variants and themes",
          arguments: [
            (BorderBeamColorVariant.colorful, true),
            (BorderBeamColorVariant.colorful, false),
            (BorderBeamColorVariant.mono,     true),
            (BorderBeamColorVariant.mono,     false),
            (BorderBeamColorVariant.ocean,    true),
            (BorderBeamColorVariant.ocean,    false),
            (BorderBeamColorVariant.sunset,   true),
            (BorderBeamColorVariant.sunset,   false),
          ])
    func lineColorsNonEmpty(variant: BorderBeamColorVariant, isDark: Bool) {
        let blobs = BeamColorPalettes.lineColors(for: variant, isDark: isDark)
        #expect(!blobs.isEmpty)
    }

    @Test("lineColors blob dimensions are positive")
    func lineBlobDimensions() {
        for variant in [BorderBeamColorVariant.colorful, .mono, .ocean, .sunset] {
            for isDark in [true, false] {
                let blobs = BeamColorPalettes.lineColors(for: variant, isDark: isDark)
                for blob in blobs {
                    #expect(blob.sizeW > 0, "sizeW must be positive for \(variant) isDark=\(isDark)")
                    #expect(blob.sizeH > 0, "sizeH must be positive for \(variant) isDark=\(isDark)")
                }
            }
        }
    }
}
