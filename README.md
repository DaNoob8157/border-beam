# BorderBeam

Animated border beam effect for SwiftUI. A lightweight Swift Package that adds a traveling glow animation around any view — cards, buttons, inputs, or search bars.

**Requirements:** iOS 15+ · macOS 12+ · Swift 5.9+

## Install

In Xcode → **File → Add Package Dependencies**, enter:

```
https://github.com/DaNoob8157/border-beam
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/DaNoob8157/border-beam", from: "1.0.0")
],
targets: [
    .target(name: "MyApp", dependencies: ["BorderBeam"])
]
```

## Quick start

```swift
import SwiftUI
import BorderBeam

struct ContentView: View {
    var body: some View {
        // Container form — wraps your view with the beam effect
        BorderBeam {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.black)
                .frame(width: 300, height: 180)
                .overlay(Text("Hello").foregroundColor(.white))
        }

        // Modifier form — apply as a view modifier
        MyCard()
            .borderBeam(size: .md, colorVariant: .ocean)
    }
}
```

## Sizes

Three built-in size presets control glow intensity and animation style:

```swift
.borderBeam(size: .md)    // Full border glow (default)
.borderBeam(size: .sm)    // Compact glow for small elements
.borderBeam(size: .line)  // Bottom-only traveling glow
```

## Color variants

```swift
.borderBeam(colorVariant: .colorful)  // Rainbow spectrum (default)
.borderBeam(colorVariant: .mono)      // Grayscale
.borderBeam(colorVariant: .ocean)     // Blue-purple tones
.borderBeam(colorVariant: .sunset)    // Orange-yellow-red tones
```

All variants except `.mono` animate through a hue-shift cycle.

## Theme

```swift
.borderBeam(theme: .dark)   // Dark background (default)
.borderBeam(theme: .light)  // Light background
.borderBeam(theme: .auto)   // Follows system color scheme
```

## Strength

Control overall intensity without affecting the wrapped content:

```swift
.borderBeam(strength: 0.7)  // 70% intensity (0–1, default 1.0)
```

## Play / pause

Toggle the animation with smooth fade transitions:

```swift
@State private var isActive = true

MyCard()
    .borderBeam(
        active: isActive,
        onActivate:   { print("faded in") },
        onDeactivate: { print("faded out") }
    )
```

## API

### `BorderBeam` container view

```swift
BorderBeam(
    size: .md,
    colorVariant: .colorful,
    theme: .dark,
    staticColors: false,
    duration: nil,
    active: true,
    cornerRadius: nil,
    brightness: 1.3,
    saturation: nil,
    hueRange: 30,
    strength: 1.0,
    onActivate: nil,
    onDeactivate: nil
) {
    /* your content */
}
```

### `.borderBeam(...)` modifier

All parameters are identical to the container form:

```swift
myView.borderBeam(
    size: .md,
    colorVariant: .colorful,
    theme: .dark,
    staticColors: false,
    duration: nil,
    active: true,
    cornerRadius: nil,
    brightness: 1.3,
    saturation: nil,
    hueRange: 30,
    strength: 1.0,
    onActivate: nil,
    onDeactivate: nil
)
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | `BorderBeamSize` | `.md` | Size preset — `.sm`, `.md`, or `.line` |
| `colorVariant` | `BorderBeamColorVariant` | `.colorful` | Color palette — `.colorful`, `.mono`, `.ocean`, `.sunset` |
| `theme` | `BorderBeamTheme` | `.dark` | Background theme — `.dark`, `.light`, `.auto` |
| `staticColors` | `Bool` | `false` | Disable hue-shift oscillation |
| `duration` | `Double?` | `nil` | Cycle duration in seconds (auto-selected from preset if `nil`) |
| `active` | `Bool` | `true` | Show / hide the beam with a fade transition |
| `cornerRadius` | `Double?` | `nil` | Corner radius in points (auto-selected from preset if `nil`) |
| `brightness` | `Double` | `1.3` | Glow brightness multiplier |
| `saturation` | `Double?` | `nil` | Glow saturation multiplier (auto if `nil`) |
| `hueRange` | `Double` | `30` | Hue oscillation range in degrees |
| `strength` | `Double` | `1.0` | Overall effect opacity (0–1) |
| `onActivate` | `(() -> Void)?` | `nil` | Called when the fade-in animation completes |
| `onDeactivate` | `(() -> Void)?` | `nil` | Called when the fade-out animation completes |

## How it works

`BorderBeam` renders a `ZStack` overlay on top of your content using SwiftUI `Canvas` and `TimelineView` for frame-by-frame animation:

- **`BorderBeamCanvas`** — `md`/`sm` variant: an angular gradient is rotated around the rounded-rectangle stroke path, with layered blur passes for the outer bloom and inner glow.
- **`LineBeamCanvas`** — `line` variant: elliptical radial-gradient blobs drawn via Core Graphics travel along the bottom edge, with edge-fade and breathing scale animations matching CSS keyframe curves.

All effect layers use `allowsHitTesting(false)` so they never intercept touches or pointer events.

## Project structure

```
BorderBeam/
├── Package.swift
├── Sources/
│   └── BorderBeam/
│       ├── BorderBeam.swift      # Container view, modifier, View extension, Canvas renderers
│       ├── ColorPalettes.swift   # Color data for all variants and themes
│       └── Types.swift           # Public enums and internal color helpers
├── Tests/
│   └── BorderBeamTests/
│       └── BorderBeamTests.swift # Unit tests for types, palettes, and color helpers
└── .github/
    └── workflows/
        └── swift-tests.yml       # CI — builds and tests on self-hosted runner
```

## License

[MIT](./LICENSE)

