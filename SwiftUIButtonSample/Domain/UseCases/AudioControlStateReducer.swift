import Foundation

// 画面からの入力(Action)を受けて次の状態を決定する純粋ロジック。
// UI実装に依存しないため、動作確認やテスト対象をここに集約できます。
struct AudioControlStateReducer {
    private let controlSpec: AudioControlSpec

    init(controlSpec: AudioControlSpec) {
        self.controlSpec = controlSpec
    }

    func reduce(state: AudioControlState, action: AudioControlAction) -> AudioControlState {
        switch action {
        case let .setValue(newValue, source):
            return applyValue(state: state, newValue: newValue, smoothFromSlider: source == .slider)
        case .applyFlat:
            return AudioControlState(
                value: controlSpec.flatValue,
                lastActiveValue: controlSpec.flatValue,
                isMuted: false
            )
        case .toggleMute:
            return toggleMute(state: state)
        }
    }

    private func toggleMute(state: AudioControlState) -> AudioControlState {
        // MUTE解除時は「最後に有効だった値」に戻す。
        if state.isMuted {
            return AudioControlState(
                value: state.lastActiveValue,
                lastActiveValue: state.lastActiveValue,
                isMuted: false
            )
        }

        var nextState = state
        if state.value > controlSpec.range.lowerBound {
            nextState.lastActiveValue = state.value
        }
        nextState.isMuted = true
        nextState.value = controlSpec.range.lowerBound
        return nextState
    }

    private func applyValue(
        state: AudioControlState,
        newValue: Double,
        smoothFromSlider: Bool
    ) -> AudioControlState {
        let clamped = clamp(newValue)
        let resolvedValue: Double

        if smoothFromSlider {
            resolvedValue = state.value + (clamped - state.value) * controlSpec.sliderSmoothingFactor
        } else {
            resolvedValue = clamped
        }

        let boundedValue = clamp(resolvedValue)

        var nextState = state
        nextState.isMuted = false
        nextState.value = boundedValue
        if boundedValue > controlSpec.range.lowerBound {
            nextState.lastActiveValue = boundedValue
        }

        return nextState
    }

    private func clamp(_ value: Double) -> Double {
        min(max(value, controlSpec.range.lowerBound), controlSpec.range.upperBound)
    }
}
