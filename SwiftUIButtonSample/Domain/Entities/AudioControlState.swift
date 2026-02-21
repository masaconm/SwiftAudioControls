import Foundation

struct AudioControlState: Equatable {
    var value: Double
    var lastActiveValue: Double
    var isMuted: Bool

    static func initial(flatValue: Double) -> AudioControlState {
        AudioControlState(
            value: flatValue,
            lastActiveValue: flatValue,
            isMuted: false
        )
    }

    func isFlat(flatValue: Double) -> Bool {
        !isMuted && abs(value - flatValue) < 0.001
    }
}
