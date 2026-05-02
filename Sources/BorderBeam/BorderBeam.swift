import SwiftUI

// MARK: - BorderBeam container view

/// A container view that wraps any content with an animated border beam effect.
///
/// ```swift
/// BorderBeam(size: .md, colorVariant: .colorful) {
///     RoundedRectangle(cornerRadius: 16)
///         .fill(.black)
///         .frame(width: 300, height: 180)
///         .overlay(Text("Hello").foregroundColor(.white))
/// }
/// ```
@available(iOS 15.0, macOS 12.0, *)
public struct BorderBeam<Content: View>: View {

    // MARK: Configuration

    let content: Content
    let size: BorderBeamSize
    let colorVariant: BorderBeamColorVariant
    let theme: BorderBeamTheme
    let staticColors: Bool
    let customDuration: Double?
    let active: Bool
    let customCornerRadius: Double?
    let brightness: Double
    let customSaturation: Double?
    let hueRange: Double
    let strength: Double
    let onActivate: (() -> Void)?
    let onDeactivate: (() -> Void)?

    // MARK: State

    @Environment(\.colorScheme) private var systemColorScheme
    @State private var beamOpacity: Double
    @State private var hueOffset: Double

    // MARK: Init

    public init(
        size: BorderBeamSize = .md,
        colorVariant: BorderBeamColorVariant = .colorful,
        theme: BorderBeamTheme = .dark,
        staticColors: Bool = false,
        duration: Double? = nil,
        active: Bool = true,
        cornerRadius: Double? = nil,
        brightness: Double = 1.3,
        saturation: Double? = nil,
        hueRange: Double = 30,
        strength: Double = 1.0,
        onActivate: (() -> Void)? = nil,
        onDeactivate: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.size = size
        self.colorVariant = colorVariant
        self.theme = theme
        self.staticColors = staticColors
        self.customDuration = duration
        self.active = active
        self.customCornerRadius = cornerRadius
        self.brightness = brightness
        self.customSaturation = saturation
        self.hueRange = hueRange
        self.strength = strength
        self.onActivate = onActivate
        self.onDeactivate = onDeactivate

        let isStatic = colorVariant == .mono || staticColors
        let effectiveHue = (size == .line ? min(hueRange, 13) : hueRange)
        _beamOpacity = State(initialValue: active ? 1 : 0)
        _hueOffset = State(initialValue: isStatic ? 0 : -effectiveHue)
    }

    // MARK: Computed properties

    private var isDark: Bool {
        switch theme {
        case .dark: return true
        case .light: return false
        case .auto: return systemColorScheme == .dark
        }
    }

    private var isStaticColors: Bool { colorVariant == .mono || staticColors }

    private var effectiveDuration: Double {
        customDuration ?? (size == .line ? 2.4 : 1.96)
    }

    private var effectiveCornerRadius: Double {
        customCornerRadius ?? (size == .sm ? 18 : 16)
    }

    private var effectiveHueRange: Double {
        size == .line ? min(hueRange, 13) : hueRange
    }

    private var effectiveSaturation: Double {
        customSaturation ?? (isDark ? 1.2 : 0.96)
    }

    /// Per-size / per-theme opacity multipliers matching the TypeScript presets.
    private var opacityConfig: (stroke: Double, inner: Double, bloom: Double) {
        let mult = colorVariant == .mono ? 0.5 : 1.0
        if isDark {
            if size == .line {
                return (0.72 * mult, 0.7 * mult, 0.8 * mult)
            } else {
                return (0.48 * mult, 0.7 * mult, 0.8 * mult)
            }
        } else {
            if size == .line {
                return (0.72 * mult, 0.7 * mult, 0.8 * mult)
            } else {
                return (0.33 * mult, 0.46 * mult, 0.54 * mult)
            }
        }
    }

    // MARK: Body

    public var body: some View {
        ZStack {
            content

            beamOverlay
                .opacity(beamOpacity * strength)
                .allowsHitTesting(false)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: effectiveCornerRadius, style: .continuous)
        )
        .onAppear { handleAppear() }
        .onChange(of: active) { newValue in handleActiveChange(newValue) }
    }

    // MARK: Beam overlay selection

    @ViewBuilder
    private var beamOverlay: some View {
        let cfg = opacityConfig
        if size == .line {
            LineBeamCanvas(
                colorVariant: colorVariant,
                isDark: isDark,
                duration: effectiveDuration,
                brightness: brightness,
                saturation: effectiveSaturation,
                strokeOpacity: cfg.stroke,
                bloomOpacity: cfg.bloom
            )
            .hueRotation(isStaticColors ? .zero : .degrees(hueOffset))
        } else {
            BorderBeamCanvas(
                size: size,
                colorVariant: colorVariant,
                isDark: isDark,
                duration: effectiveDuration,
                cornerRadius: effectiveCornerRadius,
                brightness: brightness,
                saturation: effectiveSaturation,
                strokeOpacity: cfg.stroke,
                innerOpacity: cfg.inner,
                bloomOpacity: cfg.bloom
            )
            .hueRotation(isStaticColors ? .zero : .degrees(hueOffset))
        }
    }

    // MARK: Animation helpers

    private func handleAppear() {
        withAnimation(.easeOut(duration: 0.6)) {
            beamOpacity = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            onActivate?()
        }
        guard !isStaticColors else { return }
        withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
            hueOffset = effectiveHueRange
        }
    }

    private func handleActiveChange(_ newValue: Bool) {
        if newValue {
            withAnimation(.easeOut(duration: 0.6)) { beamOpacity = 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { onActivate?() }
        } else {
            withAnimation(.easeIn(duration: 0.5)) { beamOpacity = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { onDeactivate?() }
        }
    }
}

// MARK: - ViewModifier

/// Applies the border beam effect as a modifier on any existing view.
///
/// ```swift
/// MyCard()
///     .borderBeam(size: .md, colorVariant: .ocean)
/// ```
@available(iOS 15.0, macOS 12.0, *)
public struct BorderBeamModifier: ViewModifier {
    public let size: BorderBeamSize
    public let colorVariant: BorderBeamColorVariant
    public let theme: BorderBeamTheme
    public let staticColors: Bool
    public let duration: Double?
    public let active: Bool
    public let cornerRadius: Double?
    public let brightness: Double
    public let saturation: Double?
    public let hueRange: Double
    public let strength: Double
    public let onActivate: (() -> Void)?
    public let onDeactivate: (() -> Void)?

    public init(
        size: BorderBeamSize = .md,
        colorVariant: BorderBeamColorVariant = .colorful,
        theme: BorderBeamTheme = .dark,
        staticColors: Bool = false,
        duration: Double? = nil,
        active: Bool = true,
        cornerRadius: Double? = nil,
        brightness: Double = 1.3,
        saturation: Double? = nil,
        hueRange: Double = 30,
        strength: Double = 1.0,
        onActivate: (() -> Void)? = nil,
        onDeactivate: (() -> Void)? = nil
    ) {
        self.size = size
        self.colorVariant = colorVariant
        self.theme = theme
        self.staticColors = staticColors
        self.duration = duration
        self.active = active
        self.cornerRadius = cornerRadius
        self.brightness = brightness
        self.saturation = saturation
        self.hueRange = hueRange
        self.strength = strength
        self.onActivate = onActivate
        self.onDeactivate = onDeactivate
    }

    public func body(content: Content) -> some View {
        BorderBeam(
            size: size,
            colorVariant: colorVariant,
            theme: theme,
            staticColors: staticColors,
            duration: duration,
            active: active,
            cornerRadius: cornerRadius,
            brightness: brightness,
            saturation: saturation,
            hueRange: hueRange,
            strength: strength,
            onActivate: onActivate,
            onDeactivate: onDeactivate
        ) {
            content
        }
    }
}

// MARK: - View extension

@available(iOS 15.0, macOS 12.0, *)
public extension View {
    /// Wraps the view with an animated border beam effect.
    ///
    /// - Parameters:
    ///   - size: Size/type preset (`sm`, `md`, or `line`). Default `md`.
    ///   - colorVariant: Color palette. Default `colorful`.
    ///   - theme: Background theme. Default `dark`.
    ///   - staticColors: Disable hue-shift animation. Default `false`.
    ///   - duration: Animation cycle duration in seconds.
    ///   - active: Whether the animation is playing. Default `true`.
    ///   - cornerRadius: Custom corner radius in points. Auto-selected from preset if `nil`.
    ///   - brightness: Glow brightness multiplier. Default `1.3`.
    ///   - saturation: Glow saturation multiplier. Default auto.
    ///   - hueRange: Hue rotation range in degrees. Default `30`.
    ///   - strength: Overall effect opacity (0–1). Default `1`.
    ///   - onActivate: Called when the fade-in animation completes.
    ///   - onDeactivate: Called when the fade-out animation completes.
    func borderBeam(
        size: BorderBeamSize = .md,
        colorVariant: BorderBeamColorVariant = .colorful,
        theme: BorderBeamTheme = .dark,
        staticColors: Bool = false,
        duration: Double? = nil,
        active: Bool = true,
        cornerRadius: Double? = nil,
        brightness: Double = 1.3,
        saturation: Double? = nil,
        hueRange: Double = 30,
        strength: Double = 1.0,
        onActivate: (() -> Void)? = nil,
        onDeactivate: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            BorderBeamModifier(
                size: size,
                colorVariant: colorVariant,
                theme: theme,
                staticColors: staticColors,
                duration: duration,
                active: active,
                cornerRadius: cornerRadius,
                brightness: brightness,
                saturation: saturation,
                hueRange: hueRange,
                strength: strength,
                onActivate: onActivate,
                onDeactivate: onDeactivate
            )
        )
    }
}

// MARK: - Border beam Canvas renderer (md / sm)

/// Renders the rotating border beam using Canvas and an angular gradient.
///
/// The beam is modelled as a rotating conic gradient whose stop distribution
/// encodes both the palette colours and the beam-window opacity envelope
/// (dead zone → tail → bright head → leading fade) in one pass.
@available(iOS 15.0, macOS 12.0, *)
private struct BorderBeamCanvas: View {
    let size: BorderBeamSize
    let colorVariant: BorderBeamColorVariant
    let isDark: Bool
    let duration: Double
    let cornerRadius: Double
    let brightness: Double
    let saturation: Double
    let strokeOpacity: Double
    let innerOpacity: Double
    let bloomOpacity: Double

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, canvasSize in
                let angle = rotationAngle(date: timeline.date)
                draw(in: ctx, size: canvasSize, angle: angle)
            }
        }
    }

    // MARK: Drawing

    private func draw(in ctx: GraphicsContext, size canvasSize: CGSize, angle: Double) {
        let cr = CGFloat(cornerRadius)
        // Inset by half the stroke width so the stroke stays within bounds
        let strokeLineWidth: CGFloat = self.size == .sm ? 1.0 : 1.5
        let rect = CGRect(origin: .zero, size: canvasSize)
            .insetBy(dx: strokeLineWidth / 2, dy: strokeLineWidth / 2)
        let path = Path(
            roundedRect: rect,
            cornerRadius: cr,
            style: .continuous
        )

        let colors = BeamColorPalettes.borderColors(for: colorVariant, isDark: isDark)
        let gradient = makeBeamGradient(from: colors)
        let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
        let shading = GraphicsContext.Shading.conicGradient(
            gradient,
            center: center,
            angle: Angle.degrees(angle)
        )

        // Outermost bloom: very blurred, widest stroke
        ctx.drawLayer { layer in
            layer.addFilter(.blur(radius: 14))
            layer.opacity = bloomOpacity * 0.7
            layer.stroke(path, with: shading, lineWidth: strokeLineWidth * 18)
        }

        // Mid glow: moderate blur
        ctx.drawLayer { layer in
            layer.addFilter(.blur(radius: 6))
            layer.opacity = innerOpacity
            layer.stroke(path, with: shading, lineWidth: strokeLineWidth * 7)
        }

        // Sharp stroke on top
        ctx.drawLayer { layer in
            layer.opacity = strokeOpacity
            layer.stroke(path, with: shading, lineWidth: strokeLineWidth)
        }
    }

    // MARK: Gradient construction

    /// Builds an `AngularGradient`-compatible `Gradient` that encodes both
    /// colour and the beam-window opacity envelope in a single set of stops.
    ///
    /// Layout (normalised 0→1 wrapping the full 360°):
    /// - 0.00–0.30 : dead zone (transparent)
    /// - 0.30–0.52 : beam tail fade-in
    /// - 0.52–0.80 : bright beam head (peak colours)
    /// - 0.80–0.95 : leading-edge fade-out
    /// - 0.95–1.00 : back to transparent
    private func makeBeamGradient(from colors: [BeamColor]) -> Gradient {
        let n = max(colors.count, 1)

        var stops: [Gradient.Stop] = [
            .init(color: .clear, location: 0.00),
            .init(color: .clear, location: 0.30),
        ]

        // White/dark spark at beam peak (mimics the CSS white conic overlay)
        let sparkColor: Color = isDark
            ? .white.opacity(0.60)
            : .black.opacity(0.35)
        let sparkLocation = 0.66

        for i in 0..<n {
            let frac = Double(i) / Double(n - 1)
            let loc = 0.30 + frac * 0.65   // maps to 0.30 … 0.95
            let op = beamOpacity(at: loc)
            stops.append(.init(color: colors[i].swiftUIColor(opacity: op), location: loc))
        }

        // Insert spark stop (sorted below)
        stops.append(.init(color: sparkColor, location: sparkLocation))

        stops.append(.init(color: .clear, location: 0.95))
        stops.append(.init(color: .clear, location: 1.00))

        // Gradient.Stop requires sorted locations
        stops.sort { $0.location < $1.location }
        return Gradient(stops: stops)
    }

    /// Opacity envelope that shapes the beam window: zero outside, ramp to peak,
    /// then ramp back down – mirroring the CSS conic-gradient mask profile.
    private func beamOpacity(at loc: Double) -> Double {
        let tailStart = 0.30, tailEnd = 0.52
        let headEnd   = 0.80, fadeEnd  = 0.95
        let peakOpacity = 0.80   // opacity at the brightest part of the beam head
        let peakBump    = 0.20   // extra opacity added at the very centre of the peak

        if loc <= tailStart { return 0 }
        if loc <= tailEnd {
            let t = (loc - tailStart) / (tailEnd - tailStart)
            return t * t * peakOpacity                         // quadratic ramp-in
        }
        if loc <= headEnd {
            let t = (loc - tailEnd) / (headEnd - tailEnd)
            return peakOpacity + sin(t * .pi) * peakBump       // smooth peak
        }
        if loc <= fadeEnd {
            let t = (loc - headEnd) / (fadeEnd - headEnd)
            return (1 - t) * peakOpacity                       // linear ramp-out
        }
        return 0
    }

    // MARK: Angle from time

    private func rotationAngle(date: Date) -> Double {
        let t = date.timeIntervalSinceReferenceDate
        let phase = t.truncatingRemainder(dividingBy: duration)
        return (phase / duration) * 360
    }
}

// MARK: - Line beam Canvas renderer

/// Renders the bottom-traveling glow for the `line` variant using Canvas +
/// Core Graphics for elliptical radial gradients.
@available(iOS 15.0, macOS 12.0, *)
private struct LineBeamCanvas: View {
    let colorVariant: BorderBeamColorVariant
    let isDark: Bool
    let duration: Double
    let brightness: Double
    let saturation: Double
    let strokeOpacity: Double
    let bloomOpacity: Double

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                drawLine(in: ctx, size: size, date: timeline.date)
            }
        }
    }

    // MARK: Drawing

    private func drawLine(in ctx: GraphicsContext, size: CGSize, date: Date) {
        let (beamX, widthScale, heightScale, edgeOpacity) =
            beamValues(date: date, width: size.width)
        guard edgeOpacity > 0 else { return }

        let blobs = BeamColorPalettes.lineColors(for: colorVariant, isDark: isDark)

        // Bloom layer – blurred wide glow
        ctx.drawLayer { bloom in
            bloom.addFilter(.blur(radius: 10))
            bloom.opacity = bloomOpacity * Double(edgeOpacity)
            drawBlobs(
                in: bloom, size: size, blobs: blobs,
                beamX: beamX, widthScale: widthScale * 1.6, heightScale: heightScale * 1.4
            )
        }

        // Sharp inner glow
        ctx.drawLayer { inner in
            inner.addFilter(.blur(radius: 3))
            inner.opacity = strokeOpacity * Double(edgeOpacity)
            drawBlobs(
                in: inner, size: size, blobs: blobs,
                beamX: beamX, widthScale: widthScale, heightScale: heightScale
            )
        }

        // Traveling white/dark dot (center highlight)
        ctx.drawLayer { dot in
            dot.opacity = (isDark ? 0.85 : 0.60) * Double(edgeOpacity)
            drawDot(in: dot, size: size, beamX: beamX, heightScale: heightScale)
        }
    }

    /// Draws all radial gradient blobs at the current beam position.
    private func drawBlobs(
        in ctx: GraphicsContext,
        size: CGSize,
        blobs: [LineBeamColor],
        beamX: CGFloat,
        widthScale: CGFloat,
        heightScale: CGFloat
    ) {
        for blob in blobs {
            let cx = beamX + blob.offsetX
            let cy = size.height + blob.offsetY
            let rx = blob.sizeW * widthScale
            let ry = blob.sizeH * heightScale
            guard rx > 0, ry > 0 else { continue }
            drawEllipticalRadialGradient(
                in: ctx, color: blob.color,
                cx: cx, cy: cy,
                radiusX: rx, radiusY: ry
            )
        }
    }

    /// Draws the traveling bright white dot.
    private func drawDot(
        in ctx: GraphicsContext,
        size: CGSize,
        beamX: CGFloat,
        heightScale: CGFloat
    ) {
        let dotRX: CGFloat = 22 * heightScale
        let dotRY: CGFloat = 16 * heightScale
        let dotColor = isDark
            ? BeamColor(255, 255, 255)
            : BeamColor(0, 0, 0)
        drawEllipticalRadialGradient(
            in: ctx, color: dotColor,
            cx: beamX, cy: size.height + 2,
            radiusX: dotRX, radiusY: dotRY
        )
    }

    /// Draws a single elliptical radial gradient blob via Core Graphics.
    private func drawEllipticalRadialGradient(
        in ctx: GraphicsContext,
        color: BeamColor,
        cx: CGFloat, cy: CGFloat,
        radiusX: CGFloat, radiusY: CGFloat
    ) {
        ctx.withCGContext { cg in
            cg.saveGState()
            // Translate to centre, then scale so the circle becomes an ellipse
            cg.translateBy(x: cx, y: cy)
            let scale = radiusX / max(radiusY, 0.001)
            cg.scaleBy(x: scale, y: 1.0)

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let cgColors = [
                color.cgColor(alpha: 1.0),
                color.cgColor(alpha: 0.0),
            ] as CFArray
            let locs: [CGFloat] = [0, 1]

            if let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: cgColors,
                locations: locs
            ) {
                cg.drawRadialGradient(
                    gradient,
                    startCenter: .zero, startRadius: 0,
                    endCenter: .zero,   endRadius: radiusY,
                    options: .drawsAfterEndLocation
                )
            }
            cg.restoreGState()
        }
    }

    // MARK: Beam state from time

    /// Returns (beamX in points, widthScale, heightScale, edgeOpacity) at `date`.
    /// The beam travels from the left edge (progress≈0) to the right edge
    /// (progress≈1) matching the CSS `beam-travel` keyframe curve.
    private func beamValues(
        date: Date,
        width: CGFloat
    ) -> (beamX: CGFloat, widthScale: CGFloat, heightScale: CGFloat, edgeOpacity: CGFloat) {
        let t = date.timeIntervalSinceReferenceDate
        let phase = t.truncatingRemainder(dividingBy: duration)
        let progress = CGFloat(phase / duration)      // 0 → 1

        // Travel range from CSS beam-travel keyframes: 0.06 → 0.94
        let beamTravelStart: CGFloat = 0.06
        let beamTravelEnd: CGFloat   = 0.94
        let normX = beamTravelStart + progress * (beamTravelEnd - beamTravelStart)
        let beamX = normX * width

        // Width scale: widest at centre (matching CSS 0.5→1.5 range)
        let centreDistance = abs(progress - 0.5) * 2     // 0=centre, 1=edge
        let widthScale = CGFloat(0.5 + (1.0 - centreDistance) * 1.0)

        // Height scale: slow breathing sine (simplified from CSS beam-breathe)
        let breathePhase = t.truncatingRemainder(dividingBy: duration * 1.3)
        let breatheNorm = CGFloat(breathePhase / (duration * 1.3))
        let heightScale = CGFloat(0.85 + 0.45 * sin(Double(breatheNorm) * 2 * .pi))

        // Edge fade: smooth ramp in/out at the extremes, matching beam-edge-fade
        let edgeOpacity: CGFloat
        if progress < 0.125 {
            edgeOpacity = 0
        } else if progress < 0.325 {
            edgeOpacity = CGFloat((progress - 0.125) / 0.20)
        } else if progress < 0.675 {
            edgeOpacity = 1
        } else if progress < 0.875 {
            edgeOpacity = CGFloat((0.875 - progress) / 0.20)
        } else {
            edgeOpacity = 0
        }

        return (beamX, widthScale, heightScale, edgeOpacity)
    }
}
