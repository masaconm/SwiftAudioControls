import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: AudioControlViewModel

    init(viewModel: AudioControlViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        AudioControlDemoScreen(viewModel: viewModel)
    }
}

#Preview {
    ContentView(
        viewModel: AudioControlViewModel(
            useCase: DefaultAudioControlUseCase(controlSpec: .defaultSpec),
            controlSpec: .defaultSpec
        )
    )
}
