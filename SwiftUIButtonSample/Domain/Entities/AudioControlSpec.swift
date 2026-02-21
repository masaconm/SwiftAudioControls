import Foundation

struct AudioControlSpec {
    let range: ClosedRange<Double>
    let flatValue: Double
    let sliderSmoothingFactor: Double

    static let defaultSpec = AudioControlSpec(
        range: -40...40,
        flatValue: 0,
        sliderSmoothingFactor: 0.32
    )
}
