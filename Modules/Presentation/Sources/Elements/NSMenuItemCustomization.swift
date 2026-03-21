public import AppKit

public extension NSMenuItem {
	@MainActor
	convenience init(
		title: String?,
		detail: String? = nil,
		subtitle: String? = nil,
		icon: NSImage? = nil,
		iconColor: NSColor? = nil,
		iconSpacing: CGFloat = 18,
		iconAdjustment: CGFloat = 3,
		width: CGFloat? = nil,
		enabled: Bool = true,
		badged: Bool = false,
		emphasized: Bool = false,
		monospacedDetail: Bool = false,
		submenuItems: [NSMenuItem] = [],
		shiftDetail: Bool = false,
		padDetail: Bool = false,
		action: Selector? = nil,
		target: AnyObject? = nil,
		state: NSControl.StateValue? = nil,
		representedObject: Any? = nil
	) {
		Self.swizzledTargetWidth
		Self.swizzledBadgePosition

		let detail = detail == nil && width != nil ? " " : detail
		if detail != nil || subtitle != nil || badged {
			self.init(
				title: title ?? " ",
				detail: detail,
				subtitle: subtitle,
				icon: icon,
				iconColor: iconColor,
				iconSpacing: iconSpacing,
				iconAdjustment: iconAdjustment,
				width: width ?? 325,
				badged: badged,
				emphasized: emphasized,
				monospacedDetail: monospacedDetail,
				shiftDetail: shiftDetail,
				padDetail: padDetail
			)
		} else {
			self.init()
			title.map { self.title = $0 }
		}

		isEnabled = enabled

		if !submenuItems.isEmpty {
			let submenu = NSMenu()
			submenuItems.forEach { $0.menu?.removeItem($0) }
			submenu.items = submenuItems
			self.submenu = submenu
		}

		if let action, let target {
			self.action = action
			self.target = target
		}

		if let state {
			self.state = state
		}

		self.representedObject = representedObject
	}

	@MainActor
	func updateTitle(_ title: String?) {
		guard let title else { return }

		if let attributedTitle {
			let attributes = attributedTitle.attributes(at: 0, effectiveRange: nil)
			self.attributedTitle = .init(string: title, attributes: attributes)
		} else {
			self.title = title
		}
	}

	@MainActor
	func updateDetail(_ detail: String?) {
		if let detail, badge != nil {
			self.badge = .init(string: detail)
			return
		}

		let item = NSMenuItem(
			title: title,
			detail: detail,
			// shiftDetail: submenu != nil,
			padDetail: false
		)

		attributedTitle = item.attributedTitle
		badge = item.badge
	}

	func updateSubmenuItems(_ submenuItems: [NSMenuItem]) {
		guard case let submenu = self.submenu ?? .init(), submenu.items != submenuItems else { return }

		submenuItems.forEach { $0.menu?.removeItem($0) }
		submenu.items = submenuItems
		self.submenu = submenu
	}
}

// MARK: -
@MainActor
private extension NSMenuItem {
	convenience init(
		title: String?,
		detail: String?,
		subtitle: String?,
		icon: NSImage?,
		iconColor: NSColor?,
		iconSpacing: CGFloat,
		iconAdjustment: CGFloat,
		width: CGFloat,
		badged: Bool,
		emphasized: Bool,
		monospacedDetail: Bool = false,
		shiftDetail: Bool,
		padDetail: Bool
	) {
		self.init()

		if badged {
			badge = .init(string: detail ?? "")
		}

		guard let title else { return }

		let titleFont: NSFont = .systemFont(ofSize: 13, weight: emphasized ? .semibold : .regular)
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
			let subtitleFont = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: emphasized ? .semibold : .regular)
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
		let detailFont: NSFont = monospacedDetail ? .monospacedDigitSystemFont(ofSize: 13, weight: emphasized ? .semibold : .regular) : titleFont
		let detailString = NSMutableAttributedString(
			string: detail,
			attributes: [
				.font: detailFont,
				.foregroundColor: NSColor.disabledControlTextColor
			]
		)

		let detailWidth = detailString.size().width
		let spacingWidth = width - titleWidth - detailWidth - (shiftDetail ? 16 : 0)
		let spacingString = NSAttributedString(string: " ", attributes: [.kern: spacingWidth])

		string.append(spacingString)
		if !badged {
			string.append(detailString)
			badge = nil
		}

		if padDetail {
			let paddingWidth = 12
			let paddingString = NSAttributedString(string: " ", attributes: [.kern: paddingWidth])
			string.append(paddingString)
		}

		attributedTitle = string
	}
}

private extension NSMenuItem {
	static let swizzledTargetWidth: Void = swizzleTargetWidth()
	static let swizzledBadgePosition: Void = swizzleBadgePosition()
}

private func swizzleBadgePosition() {
	guard
		let cls = NSClassFromString("NSContextMenuItemView"),
		let method = class_getInstanceMethod(cls, #selector(NSView.layout)) else { return }

	let origIMP = method_getImplementation(method)
	typealias LayoutFunc = @convention(c) (NSView, Selector) -> Void
	let origLayout = unsafeBitCast(origIMP, to: LayoutFunc.self)
	let sel = #selector(NSView.layout)

	let block: @convention(block) (NSView) -> Void = { self_ in
		origLayout(self_, sel)

		MainActor.assumeIsolated {
			let boxes = self_.subviews.filter { $0 is NSBox }
			let hasChevron = self_.subviews.contains {
				String(describing: type(of: $0)) == "_NSMenuItemTextField" && $0.frame.width < 20
			}

			guard hasChevron else { return }

			for box in boxes {
				box.frame.origin.x -= 8
			}
		}
	}

	method_setImplementation(method, imp_implementationWithBlock(block))
}

private func swizzleTargetWidth() {
	if
		let implCls = NSClassFromString("NSContextMenuImpl"),
		let maxKEIvar = class_getInstanceVariable(implCls, "_maxKEWidth") {
		let keOffset = ivar_getOffset(maxKEIvar)
		let targetWidthSel = NSSelectorFromString("_targetWidth")
		if let method = class_getInstanceMethod(implCls, targetWidthSel) {
			let origIMP = method_getImplementation(method)
			typealias Func = @convention(c) (AnyObject, Selector) -> Double
			let origFunc = unsafeBitCast(origIMP, to: Func.self)
			let block: @convention(block) (AnyObject) -> Double = { self_ in
				let original = origFunc(self_, targetWidthSel)
				let kePtr = Unmanaged.passUnretained(self_).toOpaque().advanced(by: keOffset)
				let keWidth = kePtr.load(as: Double.self)
				return original - keWidth
			}
			method_setImplementation(method, imp_implementationWithBlock(block))
		}
	}
}
