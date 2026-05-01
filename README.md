# border-beam

Animated border beam effect for React and SwiftUI. A lightweight component that adds a traveling glow animation around any element — cards, buttons, inputs, or search bars.

## Install

```bash
npm install border-beam
```

## Quick start

```tsx
import { BorderBeam } from 'border-beam';

function App() {
  return (
    <BorderBeam>
      <div style={{ padding: 32, borderRadius: 16, background: '#1d1d1d' }}>
        Your content here
      </div>
    </BorderBeam>
  );
}
```

The component wraps your content and overlays the animated beam effect. It auto-detects the `border-radius` of the first child element.

## Sizes

Three built-in size presets control the glow intensity and animation style:

```tsx
<BorderBeam size="md">  {/* Full border glow (default) */}
  <Card />
</BorderBeam>

<BorderBeam size="sm">  {/* Compact glow for small elements */}
  <IconButton />
</BorderBeam>

<BorderBeam size="line">  {/* Bottom-only traveling glow */}
  <SearchBar />
</BorderBeam>
```

## Color variants

Four color palettes are available:

```tsx
<BorderBeam colorVariant="colorful" />  {/* Rainbow spectrum (default) */}
<BorderBeam colorVariant="mono" />      {/* Grayscale */}
<BorderBeam colorVariant="ocean" />     {/* Blue-purple tones */}
<BorderBeam colorVariant="sunset" />    {/* Orange-yellow-red tones */}
```

All variants except `mono` animate through a hue-shift cycle.

## Theme

Adapts beam colors for dark or light backgrounds:

```tsx
<BorderBeam theme="dark" />   {/* Dark background (default) */}
<BorderBeam theme="light" />  {/* Light background */}
<BorderBeam theme="auto" />   {/* Detects system preference */}
```

## Strength

Control the overall intensity of the effect without affecting the wrapped content:

```tsx
<BorderBeam strength={0.7}>  {/* 70% intensity */}
  <Card />
</BorderBeam>
```

`strength` accepts a value from `0` (invisible) to `1` (full intensity, default).

## Play / pause

Toggle the animation on and off with smooth fade transitions:

```tsx
const [active, setActive] = useState(true);

<BorderBeam active={active} onDeactivate={() => console.log('faded out')}>
  <Card />
</BorderBeam>
```

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `children` | `ReactNode` | — | Content to wrap |
| `size` | `'sm' \| 'md' \| 'line'` | `'md'` | Size/type preset |
| `colorVariant` | `'colorful' \| 'mono' \| 'ocean' \| 'sunset'` | `'colorful'` | Color palette |
| `theme` | `'dark' \| 'light' \| 'auto'` | `'dark'` | Background adaptation |
| `strength` | `number` | `1` | Effect opacity (0–1), only affects the beam layers |
| `duration` | `number` | `1.96` / `2.4` | Animation cycle duration in seconds |
| `active` | `boolean` | `true` | Whether the animation is playing |
| `borderRadius` | `number` | auto-detected | Custom border radius in px |
| `brightness` | `number` | `1.3` | Glow brightness multiplier |
| `saturation` | `number` | `1.2` | Glow saturation multiplier |
| `hueRange` | `number` | `30` | Hue rotation range in degrees |
| `staticColors` | `boolean` | `false` | Disable hue-shift animation |
| `className` | `string` | — | Additional class on the wrapper |
| `style` | `CSSProperties` | — | Additional inline styles on the wrapper |
| `onActivate` | `() => void` | — | Called when fade-in completes |
| `onDeactivate` | `() => void` | — | Called when fade-out completes |

All standard `HTMLDivElement` attributes are also forwarded to the wrapper.

## How it works

`BorderBeam` renders a wrapper `<div>` with:

- **`::after`** — the beam stroke (conic gradient masked to the border)
- **`::before`** — inner glow layer
- **`[data-beam-bloom]`** — outer bloom/glow child div

All effect layers are absolutely positioned and use `pointer-events: none`, so they never interfere with your content. Animations use CSS `@property` for smooth GPU-accelerated transitions.

## Project structure

```
border-beam/
├── src/
│   ├── index.ts          # Public exports
│   ├── BorderBeam.tsx     # React component
│   ├── types.ts           # TypeScript type definitions
│   └── styles.ts          # CSS generation engine
├── demo/                  # Vite + React demo site
├── dist/                  # Built output (ESM + CJS + types)
├── package.json
├── LICENSE
└── README.md
```

## Requirements

- React 18+
- Modern browser with CSS `@property` support (Chrome 85+, Safari 15.4+, Firefox 128+)

## Accessibility

The effect layers are purely decorative and use `pointer-events: none`. They do not affect keyboard navigation or screen readers. The component respects `prefers-reduced-motion` when implemented by the consumer.

## License

[MIT](./LICENSE)

---

## SwiftUI

A native SwiftUI port lives in the `swift/` directory as a Swift Package Manager library.

**Requirements:** iOS 15+ / macOS 12+

### Install (SPM)

In Xcode → File → Add Package Dependencies, enter the repository URL and set the path to `swift/`.

Or add it to your `Package.swift`:

```swift
.package(url: "https://github.com/DaNoob8157/border-beam", from: "1.0.0")
```

### Quick start (SwiftUI)

```swift
import SwiftUI
import BorderBeam

struct ContentView: View {
    var body: some View {
        // Container form
        BorderBeam(size: .md, colorVariant: .colorful) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.black)
                .frame(width: 300, height: 180)
                .overlay(Text("Hello").foregroundColor(.white))
        }

        // Modifier form
        myCard
            .borderBeam(size: .md, colorVariant: .ocean)
    }
}
```

### SwiftUI API

```swift
BorderBeam(
    size: .md,           // .sm | .md | .line
    colorVariant: .colorful,  // .colorful | .mono | .ocean | .sunset
    theme: .dark,        // .dark | .light | .auto
    staticColors: false,
    duration: nil,       // seconds per cycle (auto-selected from preset if nil)
    active: true,        // toggle animation on/off
    cornerRadius: nil,   // points (auto-selected if nil)
    brightness: 1.3,
    saturation: nil,     // auto
    hueRange: 30,        // degrees of hue-shift oscillation
    strength: 1.0        // overall opacity multiplier
) {
    /* your content */
}
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | `BorderBeamSize` | `.md` | Size preset |
| `colorVariant` | `BorderBeamColorVariant` | `.colorful` | Color palette |
| `theme` | `BorderBeamTheme` | `.dark` | Background theme |
| `staticColors` | `Bool` | `false` | Disable hue-shift animation |
| `duration` | `Double?` | `nil` | Cycle duration in seconds |
| `active` | `Bool` | `true` | Show / hide the beam |
| `cornerRadius` | `Double?` | `nil` | Corner radius in points |
| `brightness` | `Double` | `1.3` | Glow brightness |
| `saturation` | `Double?` | `nil` | Glow saturation |
| `hueRange` | `Double` | `30` | Hue oscillation range (°) |
| `strength` | `Double` | `1.0` | Effect opacity (0–1) |
| `onActivate` | `(() -> Void)?` | `nil` | Fade-in complete callback |
| `onDeactivate` | `(() -> Void)?` | `nil` | Fade-out complete callback |

