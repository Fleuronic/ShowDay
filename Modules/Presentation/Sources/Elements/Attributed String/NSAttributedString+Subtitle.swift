import AppKit

extension NSAttributedString {
	static func subtitle(_ text: String, weight: NSFont.Weight) -> (text: NSAttributedString, spacing: NSAttributedString) {
		let font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: weight)
		let textString = NSAttributedString(string: text, attributes: [.font: font])
		let textWidth = NSAttributedString(string: text, attributes: [.font: font]).size().width
		let spacing: CGFloat = text.contains("/") ? 36 : 64
		let subtitleKern = spacing - textWidth
		let spacingString = NSAttributedString(string: " ", attributes: [.kern: subtitleKern])
		return (textString, spacingString)
	}
}
