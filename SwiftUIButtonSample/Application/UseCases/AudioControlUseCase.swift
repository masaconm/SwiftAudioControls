import Foundation

protocol AudioControlUseCase {
    func reduce(state: AudioControlState, action: AudioControlAction) -> AudioControlState
}
