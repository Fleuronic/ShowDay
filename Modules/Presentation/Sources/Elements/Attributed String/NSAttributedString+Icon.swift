import AppKit

extension NSMutableAttributedString {
	static func icon(
		_ image: NSImage,
		color: NSColor?,
		spacing: CGFloat,
		adjustment: CGFloat,
		font: NSFont
	) -> NSMutableAttributedString {
		let aspect = image.size.width / image.size.height
		let iconHeight = font.pointSize + adjustment
		let iconWidth = iconHeight * aspect

		let attachment = NSTextAttachment()
		attachment.image = image
		attachment.bounds = CGRect(
			x: 0,
			y: (font.capHeight - iconHeight).rounded() / 2,
			width: iconWidth,
			height: iconHeight
		)

		let iconAttributes = color.map { [NSAttributedString.Key.foregroundColor: $0] } ?? [:]
		let result = NSMutableAttributedString(attachment: attachment, attributes: iconAttributes)
		let spacingString = NSAttributedString(string: " ", attributes: [.kern: spacing - iconWidth])
		result.append(spacingString)
		return result
	}
}
