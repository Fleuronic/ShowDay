public import AppKit
import ObjectiveC

public class MenuItem: NSMenuItem {
	var preventsDimming = false

	public override var isEnabled: Bool {
		get { preventsDimming ? true : super.isEnabled }
		set { super.isEnabled = newValue }
	}
}

// MARK: -
public extension MenuItem {
	@MainActor
	convenience init(
		title: String? = nil,
		badgedDetail: String? = nil,
		font: NSFont? = nil,
		header: Bool = true,
		action: Selector? = nil,
		target: AnyObject? = nil,
		state: NSControl.StateValue? = nil,
		representedObject: Any? = nil
	) {
		Self.swizzledHitTest

		self.init()

		if let font, let title {
			let attributes: [NSAttributedString.Key: NSFont] = [.font: font]
			attributedTitle = .init(string: title, attributes: attributes)
			preventsDimming = header
		} else {
			title.map { self.title = $0 }
		}

		if let badgedDetail {
			badge = .init(string: badgedDetail)
		}

		if let action, let target, isEnabled {
			self.action = action
			self.target = target
		}

		if let state {
			self.state = state
		}

		self.representedObject = representedObject
	}
}

// MARK: -
private extension MenuItem {
	static let swizzledHitTest: Void = swizzleHitTest()
}

// MARK: -
private func swizzleHitTest() {
	let hitTestSel = NSSelectorFromString("hitTest:")
	let viewClassNames = ["NSMenuItemView"]
	for className in viewClassNames {
		guard
			let viewClass = NSClassFromString(className),
			let method = class_getInstanceMethod(viewClass, hitTestSel)
		else { continue }

		let origIMP = method_getImplementation(method)
		typealias Func = @convention(c) (AnyObject, Selector, NSPoint) -> NSView?
		let origFunc = unsafeBitCast(origIMP, to: Func.self)
		let block: @convention(block) (AnyObject, NSPoint) -> NSView? = { self_, point in
			if self_.responds(to: NSSelectorFromString("menuItem")),
			   let menuItem = (self_ as? NSObject)?.value(forKey: "menuItem") as? MenuItem,
			   menuItem.preventsDimming {
				return nil
			}
			return origFunc(self_, hitTestSel, point)
		}
		method_setImplementation(method, imp_implementationWithBlock(block))
	}
}
