public import AppKit

public extension NSMenuItem {
	@MainActor
	convenience init(
		title: String,
		detail: String? = nil,
		subtitle: String? = nil,
		icon: NSImage? = nil,
		iconColor: NSColor? = nil,
		iconSpacing: CGFloat = 18,
		iconAdjustment: CGFloat = 3,
		width: CGFloat? = nil,
		enabled: Bool = true,
		submenuItems: [NSMenuItem] = [],
		laysOutSubmenu: Bool = true,
		action: Selector? = nil,
		target: AnyObject? = nil
	) {
		let detail = detail == nil && width != nil ? " " : detail
		if detail != nil || subtitle != nil {
			self.init(
				title: title,
				detail: detail,
				subtitle: subtitle,
				icon: icon,
				iconColor: iconColor,
				iconSpacing: iconSpacing,
				iconAdjustment: iconAdjustment,
				width: width ?? 325,
				reduceKerning: laysOutSubmenu
			)
		} else {
			self.init(
				title: title,
				font: nil,
				enabled: enabled
			)
		}

		isEnabled = enabled
		if !submenuItems.isEmpty {
			let submenu = NSMenu()
			submenu.items = submenuItems
			self.submenu = submenu
		}
		
		if let action, let target {
			self.action = action
			self.target = target
		}
	}

	@MainActor
	convenience init(
		title: String,
		font: NSFont? = nil,
		enabled: Bool = true,
		action: Selector? = nil,
		target: AnyObject? = nil
	) {
		self.init()

		if enabled {
			if let font {
				let attributes: [NSAttributedString.Key: NSFont] = [.font: font]
				attributedTitle = .init(string: title, attributes: attributes)
			} else {
				self.title = title
				self.isEnabled = enabled
			}
		} else if let font {
			let label = NSTextField(labelWithString: title)
			label.font = font
			label.sizeToFit()
			label.frame.size.width += 24

			let containerView = NSView()
			containerView.frame = label.bounds
			containerView.addSubview(label)
			
			label.frame.origin.x = 12
			label.frame.origin.y = 3
			containerView.frame.size.height += 6
			view = containerView
		} else {
			self.title = title
			self.isEnabled = enabled
		}

		if let action, let target {
			self.action = action
			self.target = target
		}
	}
}

// MARK: -
private extension NSMenuItem {
	convenience init(
		title: String,
		detail: String?,
		subtitle: String?,
		icon: NSImage?,
		iconColor: NSColor?,
		iconSpacing: CGFloat,
		iconAdjustment: CGFloat,
		width: CGFloat,
		reduceKerning: Bool
	) {
		self.init()

		let titleFont = NSFont.systemFont(ofSize: 13)
		let string = NSMutableAttributedString(
			string: title, 
			attributes: [
				.font: titleFont, 
				.foregroundColor: NSColor.labelColor
			]
		)

		if let icon {
			let aspect = icon.size.width / icon.size.height
			let iconHeight = titleFont.pointSize + iconAdjustment
			let iconWidth = iconHeight * aspect

			let attachment = NSTextAttachment()
			attachment.image = icon
			attachment.bounds = CGRect(
				x: 0, 
				y: (titleFont.capHeight - iconHeight).rounded() / 2, 
				width: iconWidth, 
				height: iconHeight
			)

			let iconAttributes = iconColor.map { [NSAttributedString.Key.foregroundColor: $0] } ?? [:]
			let iconString = NSMutableAttributedString(attachment: attachment, attributes: iconAttributes)
			let spacingAttributes = [NSAttributedString.Key.kern: iconSpacing - iconWidth]
			let spacingString = NSAttributedString(string: " ", attributes: spacingAttributes)
			iconString.append(spacingString)
			string.insert(iconString, at: 0)
		}

		if let subtitle {
			let subtitleFont = NSFont.systemFont(ofSize: 12)
			let subtitleString = NSAttributedString(string: subtitle, attributes: [.font: subtitleFont])
			let subtitleWidth = subtitleString.size().width
			let spacing: CGFloat = subtitle.contains("/") ? 36 : 64
			let spacingString = NSAttributedString(string: " ", attributes: [.kern: spacing - subtitleWidth])
			string.insert(spacingString, at: 0)
			string.insert(subtitleString, at: 0)
		}

		guard let detail else {
			attributedTitle = string
			return
		}
		
		let titleWidth = string.size().width
		let detailString = NSMutableAttributedString(
			string: detail, 
			attributes: [
				.font: titleFont, 
				.foregroundColor: NSColor.disabledControlTextColor
			]
		)
		
		let detailWidth = detailString.size().width
		let spacingWidth = width - titleWidth - detailWidth
		let spacingString = NSAttributedString(string: " ", attributes: [.kern: spacingWidth])

		if reduceKerning {
			let lastIndex = detail.index(before: detail.endIndex)
			let afterLast = detail.index(after: lastIndex)
			let range = NSRange(lastIndex..<afterLast, in: detail)
			detailString.addAttribute(.kern, value: -CGFloat.infinity, range: range)
		}

		string.append(spacingString)
		string.append(detailString)
		attributedTitle = string
	}
}
