import Foundation

struct DefaultAudioControlUseCase: AudioControlUseCase {
    private let reducer: AudioControlStateReducer

    init(controlSpec: AudioControlSpec) {
        reducer = AudioControlStateReducer(controlSpec: controlSpec)
    }

    func reduce(state: AudioControlState, action: AudioControlAction) -> AudioControlState {
        reducer.reduce(state: state, action: action)
    }
}
