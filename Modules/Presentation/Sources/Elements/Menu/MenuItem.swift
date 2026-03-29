public import AppKit

private import ObjectiveC

public final class MenuItem: NSMenuItem {
	var style: Style?
	var storedTitle: String?
	var storedDetail: String?
	var storedSubtitle: String?
	var storedPrefix: String?
	var storedPrefixColor: NSColor?
	var storedIcon: NSImage?
	var storedIconColor: NSColor?
	var storedStackedDetail: String?
	var storedBadgedDetail: String?
	var storedAttributedTitle: NSAttributedString?
	var emphasized = false
	var preventsHighlighting = false

	private var hasPendingDeferredSync = false
}

// MARK: -
public extension MenuItem {
	override var isEnabled: Bool {
		get { preventsHighlighting ? true : super.isEnabled }
		set { super.isEnabled = newValue }
	}

	override var attributedTitle: NSAttributedString? {
		get {
			guard
				storedPrefixColor != nil,
				let base = storedAttributedTitle?.mutableCopy() as? NSMutableAttributedString else {
				return super.attributedTitle
			}

			// isHighlighted lags by one frame when menu?.highlightedItem is already set, so invert
			let effectivelyHighlighted = menu?.highlightedItem != nil ? !isHighlighted : isHighlighted

			if effectivelyHighlighted {
				base.highlight()
				return base
			} else if menu?.highlightedItem != nil {
				return base
			} else {
				restoreSuperAttributedTitleIfNeeded()
				scheduleDeferredPrefixSync()
				return storedAttributedTitle
			}
		}
		set {
			storedAttributedTitle = newValue
			super.attributedTitle = newValue
		}
	}

	func update(
		title: String? = nil,
		detail: String? = nil,
		subtitle: String? = nil,
		prefix: String? = nil,
		prefixColor: NSColor? = nil,
		emphasized: Bool? = nil,
		preventsHighlighting: Bool? = nil,
		icon: NSImage? = nil,
		iconColor: NSColor? = nil
	) {
		switch style {
		case .font:
			updateFont(
				title: title,
				detail: detail
			)
		case .columnar:
			updateColumnar(
				title: title,
				detail: detail,
				subtitle: subtitle,
				prefix: prefix,
				prefixColor: prefixColor,
				icon: icon,
				iconColor: iconColor,
				emphasized: emphasized,
				preventsHighlighting: preventsHighlighting
			)
		case nil:
			title.map { self.title = $0 }
		}
	}

	func update(submenuItems: [NSMenuItem]) {
		guard
			case let submenu = self.submenu ?? .init(),
			submenu.items != submenuItems else { return }

		submenuItems.forEach { $0.menu?.removeItem($0) }
		submenu.items = submenuItems
		self.submenu = submenu
	}
}

// MARK: -
extension MenuItem {
	enum Style {
		case font(NSFont)
		case columnar(
			iconSpacing: CGFloat,
			iconAdjustment: CGFloat,
			width: CGFloat,
			badged: Bool,
			monospacedDetail: Bool,
			shiftDetail: Bool,
			padDetail: Bool
		)
	}
}

// MARK: -
private extension MenuItem {
	func restoreSuperAttributedTitleIfNeeded() {
		guard super.attributedTitle != storedAttributedTitle else { return }

		super.attributedTitle = storedAttributedTitle
	}

	func scheduleDeferredPrefixSync() {
		guard !hasPendingDeferredSync else { return }

		hasPendingDeferredSync = true

		let modes: [RunLoop.Mode] = [.eventTracking, .default, .common]
		nonisolated(unsafe) let item = self
		CFRunLoopPerformBlock(CFRunLoopGetMain(), modes as CFArray) {
			item.hasPendingDeferredSync = false

			guard
				item.isHighlighted, item.storedPrefixColor != nil,
				let base = item.storedAttributedTitle?.mutableCopy() as? NSMutableAttributedString else { return }

			base.highlight()
			super.attributedTitle = base
		}
		CFRunLoopWakeUp(CFRunLoopGetMain())
	}
}

// MARK: -
private extension NSMutableAttributedString {
	func highlight() {
		addAttribute(.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: length))
	}
}
