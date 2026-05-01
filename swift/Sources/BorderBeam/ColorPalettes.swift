import SwiftUI

// MARK: - Color palette data
// RGB values are taken directly from the TypeScript source (styles.ts).

enum BeamColorPalettes {

    // MARK: Border variant palettes (md / sm)

    static func borderColors(
        for variant: BorderBeamColorVariant,
        isDark: Bool
    ) -> [BeamColor] {
        switch variant {
        case .colorful: return isDark ? colorfulBorderDark : colorfulBorderLight
        case .mono:     return isDark ? monoBorderDark     : monoBorderLight
        case .ocean:    return isDark ? oceanBorderDark    : oceanBorderLight
        case .sunset:   return isDark ? sunsetBorderDark   : sunsetBorderLight
        }
    }

    // colorful – dark
    private static let colorfulBorderDark: [BeamColor] = [
        BeamColor(255,  50, 100),   // pink/red
        BeamColor(255, 120,  40),   // orange
        BeamColor( 50, 200,  80),   // green
        BeamColor( 30, 185, 170),   // teal
        BeamColor( 40, 140, 255),   // blue
        BeamColor(100,  70, 255),   // purple
        BeamColor(240,  50, 180),   // magenta
    ]

    // colorful – light (slightly more saturated / darker to remain visible)
    private static let colorfulBorderLight: [BeamColor] = [
        BeamColor(200,  20,  70),
        BeamColor(200,  90,  10),
        BeamColor( 20, 140,  50),
        BeamColor( 10, 140, 130),
        BeamColor( 20,  90, 200),
        BeamColor( 60,  30, 180),
        BeamColor(170,  10, 130),
    ]

    // mono – dark
    private static let monoBorderDark: [BeamColor] = [
        BeamColor(180, 180, 180),
        BeamColor(160, 160, 160),
        BeamColor(175, 175, 175),
        BeamColor(155, 155, 155),
        BeamColor(170, 170, 170),
        BeamColor(165, 165, 165),
        BeamColor(185, 185, 185),
    ]

    // mono – light
    private static let monoBorderLight: [BeamColor] = [
        BeamColor( 80,  80,  80),
        BeamColor(100, 100, 100),
        BeamColor( 90,  90,  90),
        BeamColor(110, 110, 110),
        BeamColor( 85,  85,  85),
        BeamColor( 95,  95,  95),
        BeamColor( 75,  75,  75),
    ]

    // ocean – dark
    private static let oceanBorderDark: [BeamColor] = [
        BeamColor( 60, 120, 255),
        BeamColor( 80, 100, 200),
        BeamColor(100,  80, 220),
        BeamColor(130,  70, 255),
        BeamColor( 90, 110, 230),
        BeamColor( 70, 130, 255),
        BeamColor(120,  80, 255),
    ]

    // ocean – light
    private static let oceanBorderLight: [BeamColor] = [
        BeamColor( 40,  80, 200),
        BeamColor( 60,  80, 170),
        BeamColor( 70,  50, 180),
        BeamColor( 90,  40, 200),
        BeamColor( 60,  80, 190),
        BeamColor( 50,  90, 200),
        BeamColor( 80,  50, 200),
    ]

    // sunset – dark
    private static let sunsetBorderDark: [BeamColor] = [
        BeamColor(255,  80,  50),
        BeamColor(255, 120,  40),
        BeamColor(255, 160,  40),
        BeamColor(255, 200,  50),
        BeamColor(255, 140,  50),
        BeamColor(255, 100,  60),
        BeamColor(255,  60,  60),
    ]

    // sunset – light
    private static let sunsetBorderLight: [BeamColor] = [
        BeamColor(200,  50,  20),
        BeamColor(200,  90,  10),
        BeamColor(190, 120,  20),
        BeamColor(180, 160,  20),
        BeamColor(190, 100,  20),
        BeamColor(200,  60,  30),
        BeamColor(180,  30,  30),
    ]

    // MARK: Line variant palettes

    static func lineColors(
        for variant: BorderBeamColorVariant,
        isDark: Bool
    ) -> [LineBeamColor] {
        switch variant {
        case .colorful: return isDark ? colorfulLineDark : colorfulLineLight
        case .mono:     return isDark ? monoLineDark     : monoLineLight
        case .ocean:    return isDark ? oceanLineDark    : oceanLineLight
        case .sunset:   return isDark ? sunsetLineDark   : sunsetLineLight
        }
    }

    // colorful line – dark  (from lineColorPalettes.colorful.dark)
    private static let colorfulLineDark: [LineBeamColor] = [
        LineBeamColor(color: BeamColor(255,  50, 100), sizeW: 36, sizeH: 36, offsetX:   0, offsetY:  2),
        LineBeamColor(color: BeamColor( 40, 180, 220), sizeW: 30, sizeH: 32, offsetX:  39, offsetY:  0),
        LineBeamColor(color: BeamColor( 50, 200,  80), sizeW: 33, sizeH: 28, offsetX: -36, offsetY:  2),
        LineBeamColor(color: BeamColor(180,  40, 240), sizeW: 29, sizeH: 34, offsetX: -54, offsetY:  0),
        LineBeamColor(color: BeamColor(255, 160,  30), sizeW: 27, sizeH: 30, offsetX:  51, offsetY: -1),
        LineBeamColor(color: BeamColor(100,  70, 255), sizeW: 36, sizeH: 24, offsetX:  21, offsetY:  1),
        LineBeamColor(color: BeamColor( 40, 140, 255), sizeW: 30, sizeH: 22, offsetX: -21, offsetY:  0),
        LineBeamColor(color: BeamColor(240,  50, 180), sizeW: 25, sizeH: 28, offsetX:  66, offsetY:  1),
        LineBeamColor(color: BeamColor( 30, 185, 170), sizeW: 23, sizeH: 30, offsetX: -66, offsetY: -1),
    ]

    // colorful line – light
    private static let colorfulLineLight: [LineBeamColor] = [
        LineBeamColor(color: BeamColor(255,  50, 100), sizeW: 45, sizeH: 36, offsetX:   0, offsetY:  2),
        LineBeamColor(color: BeamColor( 40, 140, 255), sizeW: 35, sizeH: 32, offsetX:  65, offsetY:  0),
        LineBeamColor(color: BeamColor( 50, 200,  80), sizeW: 40, sizeH: 28, offsetX: -60, offsetY:  2),
        LineBeamColor(color: BeamColor(180,  40, 240), sizeW: 35, sizeH: 34, offsetX: -90, offsetY:  0),
        LineBeamColor(color: BeamColor( 30, 185, 170), sizeW: 38, sizeH: 30, offsetX:  85, offsetY: -1),
        LineBeamColor(color: BeamColor(100,  70, 255), sizeW: 50, sizeH: 24, offsetX:  35, offsetY:  1),
        LineBeamColor(color: BeamColor( 40, 140, 255), sizeW: 40, sizeH: 22, offsetX: -35, offsetY:  0),
        LineBeamColor(color: BeamColor(255, 120,  40), sizeW: 35, sizeH: 28, offsetX: 110, offsetY:  1),
        LineBeamColor(color: BeamColor(240,  50, 180), sizeW: 30, sizeH: 30, offsetX:-110, offsetY: -1),
    ]

    // mono line – dark
    private static let monoLineDark: [LineBeamColor] = [
        LineBeamColor(color: BeamColor(200, 200, 200), sizeW: 36, sizeH: 36, offsetX:   0, offsetY:  2),
        LineBeamColor(color: BeamColor(170, 170, 170), sizeW: 30, sizeH: 32, offsetX:  39, offsetY:  0),
        LineBeamColor(color: BeamColor(155, 155, 155), sizeW: 33, sizeH: 28, offsetX: -36, offsetY:  2),
        LineBeamColor(color: BeamColor(185, 185, 185), sizeW: 29, sizeH: 34, offsetX: -54, offsetY:  0),
        LineBeamColor(color: BeamColor(165, 165, 165), sizeW: 27, sizeH: 30, offsetX:  51, offsetY: -1),
        LineBeamColor(color: BeamColor(180, 180, 180), sizeW: 36, sizeH: 24, offsetX:  21, offsetY:  1),
        LineBeamColor(color: BeamColor(160, 160, 160), sizeW: 30, sizeH: 22, offsetX: -21, offsetY:  0),
        LineBeamColor(color: BeamColor(175, 175, 175), sizeW: 25, sizeH: 28, offsetX:  66, offsetY:  1),
        LineBeamColor(color: BeamColor(190, 190, 190), sizeW: 23, sizeH: 30, offsetX: -66, offsetY: -1),
    ]

    // mono line – light
    private static let monoLineLight: [LineBeamColor] = [
        LineBeamColor(color: BeamColor(100, 100, 100), sizeW: 45, sizeH: 36, offsetX:   0, offsetY:  2),
        LineBeamColor(color: BeamColor( 80,  80,  80), sizeW: 35, sizeH: 32, offsetX:  65, offsetY:  0),
        LineBeamColor(color: BeamColor( 90,  90,  90), sizeW: 40, sizeH: 28, offsetX: -60, offsetY:  2),
        LineBeamColor(color: BeamColor( 70,  70,  70), sizeW: 35, sizeH: 34, offsetX: -90, offsetY:  0),
        LineBeamColor(color: BeamColor( 85,  85,  85), sizeW: 38, sizeH: 30, offsetX:  85, offsetY: -1),
        LineBeamColor(color: BeamColor( 95,  95,  95), sizeW: 50, sizeH: 24, offsetX:  35, offsetY:  1),
        LineBeamColor(color: BeamColor( 75,  75,  75), sizeW: 40, sizeH: 22, offsetX: -35, offsetY:  0),
        LineBeamColor(color: BeamColor(105, 105, 105), sizeW: 35, sizeH: 28, offsetX: 110, offsetY:  1),
        LineBeamColor(color: BeamColor( 65,  65,  65), sizeW: 30, sizeH: 30, offsetX:-110, offsetY: -1),
    ]

    // ocean line – dark
    private static let oceanLineDark: [LineBeamColor] = [
        LineBeamColor(color: BeamColor(100,  80, 220), sizeW: 36, sizeH: 36, offsetX:   0, offsetY:  2),
        LineBeamColor(color: BeamColor( 60, 120, 255), sizeW: 30, sizeH: 32, offsetX:  39, offsetY:  0),
        LineBeamColor(color: BeamColor( 80, 100, 200), sizeW: 33, sizeH: 28, offsetX: -36, offsetY:  2),
        LineBeamColor(color: BeamColor(130,  70, 255), sizeW: 29, sizeH: 34, offsetX: -54, offsetY:  0),
        LineBeamColor(color: BeamColor( 70, 130, 255), sizeW: 27, sizeH: 30, offsetX:  51, offsetY: -1),
        LineBeamColor(color: BeamColor(120,  80, 255), sizeW: 36, sizeH: 24, offsetX:  21, offsetY:  1),
        LineBeamColor(color: BeamColor( 90, 110, 230), sizeW: 30, sizeH: 22, offsetX: -21, offsetY:  0),
        LineBeamColor(color: BeamColor(110,  90, 240), sizeW: 25, sizeH: 28, offsetX:  66, offsetY:  1),
        LineBeamColor(color: BeamColor(140, 100, 255), sizeW: 23, sizeH: 30, offsetX: -66, offsetY: -1),
    ]

    // ocean line – light
    private static let oceanLineLight: [LineBeamColor] = [
        LineBeamColor(color: BeamColor( 80,  60, 200), sizeW: 45, sizeH: 36, offsetX:   0, offsetY:  2),
        LineBeamColor(color: BeamColor( 50, 100, 220), sizeW: 35, sizeH: 32, offsetX:  65, offsetY:  0),
        LineBeamColor(color: BeamColor( 70,  90, 190), sizeW: 40, sizeH: 28, offsetX: -60, offsetY:  2),
        LineBeamColor(color: BeamColor(110,  60, 220), sizeW: 35, sizeH: 34, offsetX: -90, offsetY:  0),
        LineBeamColor(color: BeamColor( 60, 110, 230), sizeW: 38, sizeH: 30, offsetX:  85, offsetY: -1),
        LineBeamColor(color: BeamColor(100,  70, 240), sizeW: 50, sizeH: 24, offsetX:  35, offsetY:  1),
        LineBeamColor(color: BeamColor( 80, 100, 210), sizeW: 40, sizeH: 22, offsetX: -35, offsetY:  0),
        LineBeamColor(color: BeamColor( 90,  80, 225), sizeW: 35, sizeH: 28, offsetX: 110, offsetY:  1),
        LineBeamColor(color: BeamColor(120,  90, 245), sizeW: 30, sizeH: 30, offsetX:-110, offsetY: -1),
    ]

    // sunset line – dark
    private static let sunsetLineDark: [LineBeamColor] = [
        LineBeamColor(color: BeamColor(255, 100,  60), sizeW: 36, sizeH: 36, offsetX:   0, offsetY:  2),
        LineBeamColor(color: BeamColor(255, 180,  50), sizeW: 30, sizeH: 32, offsetX:  39, offsetY:  0),
        LineBeamColor(color: BeamColor(255, 140,  70), sizeW: 33, sizeH: 28, offsetX: -36, offsetY:  2),
        LineBeamColor(color: BeamColor(255,  80,  80), sizeW: 29, sizeH: 34, offsetX: -54, offsetY:  0),
        LineBeamColor(color: BeamColor(255, 200,  60), sizeW: 27, sizeH: 30, offsetX:  51, offsetY: -1),
        LineBeamColor(color: BeamColor(255, 120,  50), sizeW: 36, sizeH: 24, offsetX:  21, offsetY:  1),
        LineBeamColor(color: BeamColor(255, 160,  80), sizeW: 30, sizeH: 22, offsetX: -21, offsetY:  0),
        LineBeamColor(color: BeamColor(255,  90,  60), sizeW: 25, sizeH: 28, offsetX:  66, offsetY:  1),
        LineBeamColor(color: BeamColor(255,  70,  70), sizeW: 23, sizeH: 30, offsetX: -66, offsetY: -1),
    ]

    // sunset line – light
    private static let sunsetLineLight: [LineBeamColor] = [
        LineBeamColor(color: BeamColor(220,  80,  40), sizeW: 45, sizeH: 36, offsetX:   0, offsetY:  2),
        LineBeamColor(color: BeamColor(230, 150,  30), sizeW: 35, sizeH: 32, offsetX:  65, offsetY:  0),
        LineBeamColor(color: BeamColor(210, 110,  50), sizeW: 40, sizeH: 28, offsetX: -60, offsetY:  2),
        LineBeamColor(color: BeamColor(200,  60,  60), sizeW: 35, sizeH: 34, offsetX: -90, offsetY:  0),
        LineBeamColor(color: BeamColor(220, 170,  40), sizeW: 38, sizeH: 30, offsetX:  85, offsetY: -1),
        LineBeamColor(color: BeamColor(210, 100,  30), sizeW: 50, sizeH: 24, offsetX:  35, offsetY:  1),
        LineBeamColor(color: BeamColor(230, 130,  60), sizeW: 40, sizeH: 22, offsetX: -35, offsetY:  0),
        LineBeamColor(color: BeamColor(190,  70,  50), sizeW: 35, sizeH: 28, offsetX: 110, offsetY:  1),
        LineBeamColor(color: BeamColor(180,  50,  50), sizeW: 30, sizeH: 30, offsetX:-110, offsetY: -1),
    ]
}
