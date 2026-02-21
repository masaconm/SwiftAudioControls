import SwiftUI

struct VerticalLinkedSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(AudioUIColorToken.sliderPanel)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AudioUIColorToken.sliderBorder, lineWidth: 1)
                )
                .frame(
                    width: AudioUIMetrics.sliderPanelWidth,
                    height: AudioUIMetrics.sliderPanelHeight
                )

            Rectangle()
                .fill(AudioUIColorToken.sliderTrackLine)
                .frame(width: AudioUIMetrics.sliderLineWidth, height: 190)

            Slider(value: $value, in: range)
                .tint(AudioUIColorToken.accent)
                .frame(width: 208)
                .rotationEffect(.degrees(-90))
        }
        .frame(
            width: AudioUIMetrics.sliderContainerWidth,
            height: AudioUIMetrics.sliderContainerHeight
        )
    }
}
