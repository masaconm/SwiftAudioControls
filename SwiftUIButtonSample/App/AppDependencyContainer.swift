import Foundation

struct AppDependencyContainer {
    private let controlSpec: AudioControlSpec
    private let useCase: any AudioControlUseCase

    init(controlSpec: AudioControlSpec = .defaultSpec) {
        self.controlSpec = controlSpec
        useCase = DefaultAudioControlUseCase(controlSpec: controlSpec)
    }

    @MainActor
    func makeViewModel() -> AudioControlViewModel {
        AudioControlViewModel(
            useCase: useCase,
            controlSpec: controlSpec
        )
    }
}
