import SwiftUI
import Combine

@MainActor
final class AudioControlViewModel: ObservableObject {
    private let useCase: any AudioControlUseCase
    private let controlSpec: AudioControlSpec

    @Published private(set) var state: AudioControlState

    init(
        useCase: any AudioControlUseCase,
        controlSpec: AudioControlSpec
    ) {
        self.useCase = useCase
        self.controlSpec = controlSpec
        state = AudioControlState.initial(flatValue: controlSpec.flatValue)
    }

    var valueRange: ClosedRange<Double> {
        controlSpec.range
    }

    var flatValue: Double {
        controlSpec.flatValue
    }

    var value: Double {
        state.value
    }

    var isMuted: Bool {
        state.isMuted
    }

    var isFlat: Bool {
        state.isFlat(flatValue: controlSpec.flatValue)
    }

    func setFromKnob(_ newValue: Double) {
        apply(action: .setValue(newValue, source: .knob))
    }

    func setFromSlider(_ newValue: Double) {
        apply(action: .setValue(newValue, source: .slider))
    }

    func applyFlat() {
        apply(action: .applyFlat)
    }

    func toggleMute() {
        apply(action: .toggleMute)
    }

    private func apply(action: AudioControlAction) {
        state = useCase.reduce(state: state, action: action)
    }
}
