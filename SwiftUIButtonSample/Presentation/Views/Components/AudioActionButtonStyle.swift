import SwiftUI

struct AudioActionButtonStyle: ButtonStyle {
    var isActive: Bool = false
    var activeBackground: Color = AudioUIColorToken.muteActive
    var inactiveBackground: Color = AudioUIColorToken.buttonInactive
    var activeForeground: Color = AudioUIColorToken.controlForeground
    var inactiveForeground: Color = AudioUIColorToken.controlForeground
    var borderColor: Color = AudioUIColorToken.buttonBorder
    var width: CGFloat = AudioUIMetrics.controlButtonWidth
    var height: CGFloat = AudioUIMetrics.controlButtonHeight
    var cornerRadius: CGFloat = AudioUIMetrics.controlButtonRadius
    var fontSize: CGFloat = AudioUIMetrics.controlButtonFontSize

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: fontSize, weight: .bold, design: .rounded))
            .foregroundStyle(isActive ? activeForeground : inactiveForeground)
            .frame(width: width, height: height)
            .background(isActive ? activeBackground : inactiveBackground)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
            .cornerRadius(cornerRadius)
            .shadow(
                color: isActive ? activeBackground.opacity(0.72) : borderColor.opacity(0),
                radius: isActive ? 9 : 0
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
