public import AppKit

// MARK: - Columnar Initialization
public extension MenuItem {
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
		prefix: String? = nil,
		prefixColor: NSColor? = nil,
		submenuItems: [MenuItem] = [],
		shiftDetail: Bool = false,
		padDetail: Bool = false,
		preventsHighlighting: Bool = false,
		action: Selector? = nil,
		target: AnyObject? = nil,
		state: NSControl.StateValue? = nil,
		representedObject: Any? = nil
	) {
		Self.swizzledTargetWidth
		Self.swizzledBadgePosition

		self.init()

		let detail = detail == nil && width != nil ? " " : detail
		if detail != nil || subtitle != nil || badged {
			storedTitle = title
			storedDetail = detail
			storedSubtitle = subtitle
			storedPrefix = prefix
			storedPrefixColor = prefixColor
			storedIcon = icon
			storedIconColor = iconColor
			style = .columnar(
				iconSpacing: iconSpacing,
				iconAdjustment: iconAdjustment,
				width: width ?? 325,
				badged: badged,
				monospacedDetail: monospacedDetail,
				shiftDetail: shiftDetail,
				padDetail: padDetail
			)

			self.emphasized = emphasized
			self.preventsHighlighting = preventsHighlighting

			rebuildColumnarAttributedTitle()
		} else {
			title.map { self.title = $0 }
		}

		isEnabled = enabled

		if !submenuItems.isEmpty {
			let submenu = NSMenu()
			submenuItems.forEach { $0.menu?.removeItem($0) }
			submenu.items = submenuItems
			self.submenu = submenu
		}

		if enabled, let action, let target {
			self.action = action
			self.target = target
		}

		if let state {
			self.state = state
		}

		self.emphasized = emphasized
		self.representedObject = representedObject
	}
}

// MARK: - Columnar Update
extension MenuItem {
	func updateColumnar(
		title: String?,
		detail: String?,
		subtitle: String?,
		prefix: String?,
		prefixColor: NSColor?,
		icon: NSImage?,
		iconColor: NSColor?,
		emphasized: Bool? = nil,
		preventsHighlighting: Bool? = nil
	) {
		guard case .columnar = style else { return }

		let titleChanged = title != storedTitle
		let detailChanged = detail != storedDetail
		let subtitleChanged = subtitle != storedSubtitle
		let iconChanged = icon !== storedIcon || iconColor != storedIconColor
		let prefixChanged = prefix != storedPrefix || prefixColor != storedPrefixColor
		let emphasizedChanged = emphasized.map { $0 != self.emphasized } ?? false
		let preventsHighlightingChanged = preventsHighlighting.map { $0 != self.preventsHighlighting } ?? false

		guard titleChanged || detailChanged || subtitleChanged || iconChanged || prefixChanged || emphasizedChanged || preventsHighlightingChanged else { return }

		storedTitle = title
		storedDetail = detail
		storedSubtitle = subtitle
		storedPrefix = prefix
		storedPrefixColor = prefixColor
		storedIcon = icon
		storedIconColor = iconColor
		emphasized.map { self.emphasized = $0 }
		preventsHighlighting.map { self.preventsHighlighting = $0 }

		rebuildColumnarAttributedTitle()
	}
}

// MARK: -
private extension MenuItem {
	func rebuildColumnarAttributedTitle() {
		guard case let .columnar(
			iconSpacing,
			iconAdjustment,
			width,
			badged,
			monospacedDetail,
			shiftDetail,
			padDetail
		) = style else { return }

		if badged {
			badge = .init(string: storedDetail ?? "")
		}

		let title = storedTitle ?? " "
		let fontSize: CGFloat = 13
		let titleFont: NSFont = .systemFont(ofSize: fontSize, weight: emphasized ? .semibold : .regular)
		let string = NSMutableAttributedString(
			string: title,
			attributes: [
				.font: titleFont,
				.foregroundColor: NSColor.labelColor
			]
		)

		if let icon = storedIcon {
			let iconString = NSMutableAttributedString.icon(icon, color: storedIconColor, spacing: iconSpacing, adjustment: iconAdjustment, font: titleFont)
			string.insert(iconString, at: 0)
		}

		if let subtitle = storedSubtitle {
			let (subtitleString, spacingString) = NSAttributedString.subtitle(subtitle, weight: emphasized ? .semibold : .regular)
			string.insert(spacingString, at: 0)
			string.insert(subtitleString, at: 0)
		}

		guard let detail = storedDetail else {
			attributedTitle = string
			return
		}

		let titleWidth = string.size().width
		let fontWeight: NSFont.Weight = emphasized ? .semibold : .regular
		let detailFont: NSFont = monospacedDetail ? .monospacedDigitSystemFont(ofSize: fontSize, weight: fontWeight) : titleFont

		var prefixWidth: CGFloat = 0
		var prefixString: NSMutableAttributedString?
		if let prefix = storedPrefix {
			let prefixFontSize: CGFloat = 11
			let prefixFont = NSFont.monospacedDigitSystemFont(ofSize: prefixFontSize, weight: fontWeight)
			let baselineOffset = (fontSize - prefixFontSize) / 2 * 0.4
			let color = storedPrefixColor ?? .init(calibratedWhite: 0, alpha: 0.35)
			let string = NSMutableAttributedString(
				string: prefix + "  ",
				attributes: [
					.font: prefixFont,
					.foregroundColor: color,
					.baselineOffset: baselineOffset
				]
			)
			prefixWidth = string.size().width
			prefixString = string
		}

		let detailString = NSMutableAttributedString(
			string: detail,
			attributes: [
				.font: detailFont,
				.foregroundColor: NSColor(calibratedWhite: 0, alpha: 0.35)
			]
		)

		let detailWidth = detailString.size().width
		let spacingWidth = width - titleWidth - prefixWidth - detailWidth - (shiftDetail ? 16 : 0)
		let spacingString = NSAttributedString(string: " ", attributes: [.kern: spacingWidth])
		string.append(spacingString)

		if !badged {
			if let prefixString {
				string.append(prefixString)
			}
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

// MARK: -
private extension NSMenuItem {
	static let swizzledTargetWidth: Void = swizzleTargetWidth()
	static let swizzledBadgePosition: Void = swizzleBadgePosition()

	static func swizzleBadgePosition() {
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

	static func swizzleTargetWidth() {
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
}
