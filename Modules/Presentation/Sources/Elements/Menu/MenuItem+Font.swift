public import AppKit

public extension MenuItem {
	convenience init(
		title: String,
		stackedDetail: String? = nil,
		badgedDetail: String? = nil,
		font: NSFont,
		header: Bool = true,
		state: NSControl.StateValue? = nil,
		representedObject: Any? = nil
	) {
		Self.swizzledHitTest

		self.init()

		storedTitle = title
		storedStackedDetail = stackedDetail
		storedBadgedDetail = badgedDetail
		style = .font(font)
		preventsHighlighting = header

		if let stackedDetail = stackedDetail {
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = 2
			let displayTitle = [title, stackedDetail].joined(separator: "\n")
			let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
			attributedTitle = .init(string: displayTitle, attributes: attributes)
		} else {
			let attributes: [NSAttributedString.Key: NSFont] = [.font: font]
			attributedTitle = .init(string: title, attributes: attributes)
		}

		badge = badgedDetail.map { .init(string: $0) }

		state.map { self.state = $0 }
		self.representedObject = representedObject
	}
}

// MARK: -
extension MenuItem {
	func updateFont(
		title: String?,
		detail: String?
	) {
		let titleChanged = title != storedTitle
		let detailChanged = detail != storedBadgedDetail && detail != storedStackedDetail

		guard titleChanged || detailChanged else { return }

		if title != storedTitle {
			if let title, let current = attributedTitle?.mutableCopy() as? NSMutableAttributedString {
				current.replaceCharacters(in: NSRange(location: 0, length: current.length), with: title)
				attributedTitle = current
			}

			storedTitle = title
		}

		if storedBadgedDetail != nil {
			if detail != storedBadgedDetail {
				badge = detail.map { .init(string: $0) }
			}

			storedBadgedDetail = detail
		} else if storedStackedDetail != nil, let detail {
			if
				let title = title ?? storedTitle,
				let current = attributedTitle?.mutableCopy() as? NSMutableAttributedString {
				let newText = [title, detail].joined(separator: "\n")
				current.replaceCharacters(in: NSRange(location: 0, length: current.length), with: newText)
				attributedTitle = current
			}

			storedStackedDetail = detail
		}
	}
}

// MARK: -
private extension MenuItem {
	static let swizzledHitTest: Void = swizzleHitTest()

	static func swizzleHitTest() {
		let hitTestSel = NSSelectorFromString("hitTest:")
		let viewClassNames = ["NSMenuItemView"]
		for className in viewClassNames {
			guard
				let viewClass = NSClassFromString(className),
				let method = class_getInstanceMethod(viewClass, hitTestSel) else { continue }

			let origIMP = method_getImplementation(method)
			typealias Func = @convention(c) (AnyObject, Selector, NSPoint) -> NSView?
			let origFunc = unsafeBitCast(origIMP, to: Func.self)
			let block: @convention(block) (AnyObject, NSPoint) -> NSView? = { self_, point in
				if
					self_.responds(to: NSSelectorFromString("menuItem")),
					let menuItem = (self_ as? NSObject)?.value(forKey: "menuItem") as? MenuItem,
					menuItem.preventsHighlighting { return nil }

				return origFunc(self_, hitTestSel, point)
			}
			method_setImplementation(method, imp_implementationWithBlock(block))
		}
	}
}