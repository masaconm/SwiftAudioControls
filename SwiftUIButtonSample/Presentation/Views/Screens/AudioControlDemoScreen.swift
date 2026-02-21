import SwiftUI

// 画面レベルのView。
// 色は AudioUIColorToken から参照し、見た目変更時は colorset を優先的に確認します。
struct AudioControlDemoScreen: View {
    @ObservedObject var viewModel: AudioControlViewModel

    private var knobBinding: Binding<Double> {
        Binding(
            get: { viewModel.value },
            set: { viewModel.setFromKnob($0) }
        )
    }

    private var sliderBinding: Binding<Double> {
        Binding(
            get: { viewModel.value },
            set: { viewModel.setFromSlider($0) }
        )
    }

    var body: some View {
        VStack(spacing: 18) {
            Text("Audio Control")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AudioUIColorToken.textPrimary.opacity(0.9))

            Text("Knob & Slider Linked Sample")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(AudioUIColorToken.textSecondary.opacity(0.9))
                .multilineTextAlignment(.center)

            HStack(alignment: .center, spacing: 26) {
                AudioKnob(
                    title: "",
                    range: viewModel.valueRange,
                    value: knobBinding,
                    knobSize: 120,
                    centerValue: viewModel.flatValue
                )

                VStack(spacing: 10) {
                    VerticalLinkedSlider(value: sliderBinding, range: viewModel.valueRange)

                    Text(String(format: "%+.1f dB", viewModel.value))
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundStyle(AudioUIColorToken.textPrimary.opacity(0.82))
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(width: 112, alignment: .center)
                }
                .frame(width: 112)
            }

            VStack(spacing: 10) {
                actionButton(
                    title: "FLAT",
                    isActive: viewModel.isFlat,
                    activeBackground: AudioUIColorToken.flatActive,
                    action: viewModel.applyFlat
                )

                actionButton(
                    title: "MUTE",
                    isActive: viewModel.isMuted,
                    activeBackground: AudioUIColorToken.muteActive,
                    action: viewModel.toggleMute
                )
            }

            Text("Knob and slider are linked")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(AudioUIColorToken.textTertiary.opacity(0.9))
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // 画面背景色トークン（AudioScreenBackground.colorset）
        .background(AudioUIColorToken.screenBackground)
        .animation(.easeOut(duration: 0.08), value: viewModel.value)
    }

    @ViewBuilder
    private func actionButton(
        title: String,
        isActive: Bool,
        activeBackground: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(
            AudioActionButtonStyle(
                isActive: isActive,
                activeBackground: activeBackground,
                // 非アクティブ時のボタン色（AudioButtonInactive.colorset）
                inactiveBackground: AudioUIColorToken.buttonInactive,
                activeForeground: AudioUIColorToken.controlForeground,
                inactiveForeground: AudioUIColorToken.controlForeground,
                borderColor: AudioUIColorToken.buttonBorder
            )
        )
    }
}

#Preview {
    AudioControlDemoScreen(
        viewModel: AudioControlViewModel(
            useCase: DefaultAudioControlUseCase(controlSpec: .defaultSpec),
            controlSpec: .defaultSpec
        )
    )
}
