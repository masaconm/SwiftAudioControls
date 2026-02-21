import SwiftUI

// 色の変更はこのファイルのトークン名ではなく、
// Assets.xcassets の各 colorset (例: AudioAccent.colorset) を編集します。
// このファイルは「どのUIがどの色トークンを使うか」をまとめる場所です。
enum AudioUIColorToken {
    // 画面全体の基調色
    static let screenBackground = Color("AudioScreenBackground")
    // 強調色（ノブの発光、スライダーTint）
    static let accent = Color("AudioAccent")
    static let labelAccent = Color("AudioLabelAccent")
    static let textPrimary = Color("AudioTextPrimary")
    static let textSecondary = Color("AudioTextSecondary")
    static let textTertiary = Color("AudioTextTertiary")

    // 操作ボタン色
    static let buttonInactive = Color("AudioButtonInactive")
    static let buttonBorder = Color("AudioButtonBorder")
    static let muteActive = Color("AudioMuteActive")
    static let flatActive = Color("AudioFlatActive")
    static let controlForeground = Color("AudioControlForeground")

    // スライダー周辺色
    static let sliderPanel = Color("AudioSliderPanel")
    static let sliderTrackLine = Color("AudioSliderTrackLine")
    static let sliderBorder = Color("AudioSliderBorder")

    // ノブ周辺色
    static let knobBodyTop = Color("AudioKnobBodyTop")
    static let knobBodyBottom = Color("AudioKnobBodyBottom")
    static let knobCoreTop = Color("AudioKnobCoreTop")
    static let knobCoreBottom = Color("AudioKnobCoreBottom")
    static let knobTick = Color("AudioKnobTick")
    static let knobPointer = Color("AudioKnobPointer")
    static let knobRing = Color("AudioKnobRing")
    static let knobOuterStroke = Color("AudioKnobOuterStroke")
    // ノブ中央のぼかしハイライト色
    static let knobHighlight = Color("AudioKnobHighlight")
    static let knobPointerGlow = Color("AudioKnobPointerGlow")
}

enum AudioUIMetrics {
    static let controlButtonWidth: CGFloat = 170
    static let controlButtonHeight: CGFloat = 56
    static let controlButtonRadius: CGFloat = 8
    static let controlButtonFontSize: CGFloat = 22

    static let sliderContainerWidth: CGFloat = 58
    static let sliderContainerHeight: CGFloat = 226
    static let sliderPanelWidth: CGFloat = 52
    static let sliderPanelHeight: CGFloat = 222
    static let sliderLineWidth: CGFloat = 2

    static let knobInnerRingWidth: CGFloat = 8
    static let knobGlowLineWidth: CGFloat = 4.2
    static let knobTickGapFromOuterRing: CGFloat = 5
}
