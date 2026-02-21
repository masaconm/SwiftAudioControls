import SwiftUI

// ノブUIコンポーネント。
// 見た目の色は AudioUIColorToken 経由で参照し、色値そのものは Assets 側で管理します。
struct AudioKnob: View {
    let title: String
    let range: ClosedRange<Double>
    @Binding var value: Double

    var knobSize: CGFloat = 64
    var centerValue: Double = 0

    private let minAngle: Double = -135
    private let maxAngle: Double = 135

    private let minInteractiveRadius: CGFloat = 6
    private let rejectJumpDeltaDegrees: Double = 80
    private let deltaGain: Double = 1.35
    private let valueSmoothing: Double = 0.55
    private let maxStepRatioPerEvent: Double = 0.12

    @GestureState private var isInteracting = false
    @State private var lastDragAngle: Double?

    private var clampedValue: Double {
        min(max(value, range.lowerBound), range.upperBound)
    }

    private var knobScale: CGFloat {
        knobSize / 54.0
    }

    private var minInteractiveRadiusScaled: CGFloat {
        minInteractiveRadius * knobScale
    }

    private var knobContainerWidth: CGFloat {
        max(60, knobSize + 6)
    }

    private var knobContainerHeight: CGFloat {
        max(68, knobSize + 14)
    }

    private var normalized: Double {
        let span = range.upperBound - range.lowerBound
        guard span != 0 else { return 0.5 }
        return (clampedValue - range.lowerBound) / span
    }

    private var centerNormalized: Double {
        let span = range.upperBound - range.lowerBound
        guard span != 0 else { return 0.5 }
        return (centerValue - range.lowerBound) / span
    }

    private var angle: Double {
        minAngle + normalized * (maxAngle - minAngle)
    }

    private var centerAngle: Double {
        minAngle + centerNormalized * (maxAngle - minAngle)
    }

    private var glowStrength: Double {
        let centered = abs(normalized - centerNormalized) * 2.0
        let interactionBoost = isInteracting ? 0.45 : 0
        return min(max(centered * 0.65 + interactionBoost, 0.30), 1.0)
    }

    private var hasGlow: Bool {
        abs(angle - centerAngle) > 0.5
    }

    private var glowStartAngle: Double {
        min(angle, centerAngle)
    }

    private var glowEndAngle: Double {
        max(angle, centerAngle)
    }

    var body: some View {
        let outerRadius = (knobSize * 0.5) - 2
        let majorTickLength = 6.5 * knobScale
        let minorTickLength = 3.5 * knobScale
        let tickCenterRadius = max((outerRadius - AudioUIMetrics.knobTickGapFromOuterRing) - (majorTickLength * 0.5), 0)

        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AudioUIColorToken.knobBodyTop, AudioUIColorToken.knobBodyBottom],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(AudioUIColorToken.knobOuterStroke.opacity(0.6), lineWidth: 2.0)
                            .padding(1)
                    )

                ForEach(0..<9, id: \.self) { idx in
                    let t = Double(idx) / 8.0
                    let tickAngle = minAngle + t * (maxAngle - minAngle)
                    let isMajorTick = (idx == 0 || idx == 4 || idx == 8)

                    Capsule()
                        .fill(AudioUIColorToken.knobTick.opacity(t <= normalized ? 0.34 : 0.12))
                        .frame(width: 1.0 * knobScale, height: isMajorTick ? majorTickLength : minorTickLength)
                        .offset(y: -tickCenterRadius)
                        .rotationEffect(.degrees(tickAngle))
                }

                if hasGlow {
                    // ノブの現在値と中央値の差分を発光で表現。
                    KnobContinuousGlowArc(startAngle: glowStartAngle, endAngle: glowEndAngle)
                        .foregroundStyle(AudioUIColorToken.accent.opacity(glowStrength * 0.65))
                        .frame(width: knobSize, height: knobSize)
                        .blur(radius: 2.2)

                    KnobContinuousGlowArc(startAngle: glowStartAngle, endAngle: glowEndAngle)
                        .foregroundStyle(AudioUIColorToken.accent.opacity(min(glowStrength + 0.22, 1.0)))
                        .frame(width: knobSize, height: knobSize)
                        .shadow(color: AudioUIColorToken.accent.opacity(glowStrength), radius: 13)
                }

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [AudioUIColorToken.knobCoreTop, AudioUIColorToken.knobCoreBottom],
                            center: .topLeading,
                            startRadius: 1,
                            endRadius: 20
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(AudioUIColorToken.knobRing.opacity(0.95), lineWidth: AudioUIMetrics.knobInnerRingWidth)
                    )
                    .padding(9 * knobScale)

                Circle()
                    // ノブ中央のぼかし。色は AudioKnobHighlight.colorset で調整可能。
                    .fill(AudioUIColorToken.knobHighlight.opacity(0.05))
                    .frame(width: 7 * knobScale, height: 7 * knobScale)
                    .blur(radius: 3.8)

                Capsule()
                    .fill(AudioUIColorToken.knobPointer)
                    .frame(width: 3 * knobScale, height: 12 * knobScale)
                    .offset(y: -12 * knobScale)
                    .rotationEffect(.degrees(angle))
                    .shadow(color: AudioUIColorToken.knobPointerGlow.opacity(0.35), radius: 1.3)
            }
            .frame(width: knobSize, height: knobSize)
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isInteracting) { _, state, _ in
                        state = true
                    }
                    .onChanged { drag in
                        let drag = dragPolar(for: drag.location, size: knobSize)
                        guard let drag else { return }
                        guard drag.radius >= minInteractiveRadiusScaled else { return }
                        let currentAngle = drag.angle

                        guard let previousAngle = lastDragAngle else {
                            lastDragAngle = currentAngle
                            return
                        }

                        var delta = normalizedSignedAngle(currentAngle - previousAngle)
                        if abs(delta) > rejectJumpDeltaDegrees {
                            lastDragAngle = currentAngle
                            return
                        }

                        delta *= deltaGain

                        let targetAngle = normalizedSignedAngle(angle + delta)
                        let mapped = valueForAngle(targetAngle)
                        let smoothedValue = clampedValue + (mapped - clampedValue) * valueSmoothing

                        let span = range.upperBound - range.lowerBound
                        let maxStepPerEvent = span * maxStepRatioPerEvent
                        let deltaValue = min(max(smoothedValue - clampedValue, -maxStepPerEvent), maxStepPerEvent)
                        value = min(max(clampedValue + deltaValue, range.lowerBound), range.upperBound)

                        lastDragAngle = currentAngle
                    }
                    .onEnded { _ in
                        lastDragAngle = nil
                    }
            )

            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AudioUIColorToken.labelAccent)

            Text(String(format: "%+.1f dB", clampedValue))
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundStyle(AudioUIColorToken.textPrimary.opacity(0.82))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(width: knobContainerWidth, height: knobContainerHeight + 34, alignment: .top)
    }

    private func dragPolar(for point: CGPoint, size: CGFloat) -> (angle: Double, radius: CGFloat)? {
        let center = CGPoint(x: size * 0.5, y: size * 0.5)
        let dx = point.x - center.x
        let dy = point.y - center.y
        let radius = sqrt(dx * dx + dy * dy)
        guard radius.isFinite else { return nil }
        return (atan2(dx, -dy) * 180.0 / .pi, radius)
    }

    private func normalizedSignedAngle(_ degrees: Double) -> Double {
        var value = degrees
        while value > 180 { value -= 360 }
        while value < -180 { value += 360 }
        return value
    }

    private func valueForAngle(_ degrees: Double) -> Double {
        let clamped = min(max(degrees, minAngle), maxAngle)
        let ratio = (clamped - minAngle) / (maxAngle - minAngle)
        return range.lowerBound + ratio * (range.upperBound - range.lowerBound)
    }
}

private struct KnobContinuousGlowArc: Shape {
    let startAngle: Double
    let endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.5 - 2.8
        let span = endAngle - startAngle
        let steps = max(24, Int(abs(span) / 2.0))

        guard steps > 0 else { return path }
        for i in 0...steps {
            let t = Double(i) / Double(steps)
            let a = startAngle + span * t
            let rad = a * .pi / 180.0
            let x = center.x + radius * CGFloat(sin(rad))
            let y = center.y - radius * CGFloat(cos(rad))
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path.strokedPath(
            StrokeStyle(lineWidth: AudioUIMetrics.knobGlowLineWidth, lineCap: .round, lineJoin: .round)
        )
    }
}
