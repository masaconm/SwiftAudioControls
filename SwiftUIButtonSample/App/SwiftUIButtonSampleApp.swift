import SwiftUI

@main
struct SwiftUIButtonSampleApp: App {
    private let dependencies = AppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: dependencies.makeViewModel())
        }
    }
}
