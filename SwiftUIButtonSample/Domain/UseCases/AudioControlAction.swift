import Foundation

enum AudioControlInputSource: Equatable {
    case knob
    case slider
}

enum AudioControlAction {
    case setValue(Double, source: AudioControlInputSource)
    case applyFlat
    case toggleMute
}
