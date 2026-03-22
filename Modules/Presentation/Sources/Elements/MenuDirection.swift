private import AppKit
private import ObjectiveC

// MARK: - Force deep submenus to open left
public enum MenuDirection {}

public extension MenuDirection {
	static func standardize() {
		guard let cls = NSClassFromString("NSPopupMenuWindow") else { return }
		let sel = NSSelectorFromString("_positionSubmenuHorizontally:withMenuWidth:inParentItemBounds:withInsets:allowingOverlap:")
		guard let method = class_getInstanceMethod(cls, sel) else { return }

		let block: @convention(block) (AnyObject, Int, Double, CGRect, NSEdgeInsets, Bool) -> Double = { obj, direction, menuWidth, parentBounds, insets, allowOverlap in
			let depth = menuDepth(of: obj)
			return depth < 3 ? parentBounds.minX - menuWidth : parentBounds.maxX - 300
		}

		method_setImplementation(method, imp_implementationWithBlock(block))
	}
}

private extension MenuDirection {
	static func menuDepth(of window: AnyObject) -> Int {
		guard
			case let implSel = NSSelectorFromString("associatedImpl"),
			window.responds(to: implSel),
			let implResult = window.perform(implSel)?.takeUnretainedValue(),
			case let menuSel = NSSelectorFromString("menu"),
			implResult.responds(to: menuSel),
			let menuObj = implResult.perform(menuSel)?.takeUnretainedValue() as? NSMenu else { return 0 }

		var depth = 0
		var current: NSMenu? = menuObj

		while let sup = current?.supermenu {
			depth += 1
			current = sup
		}

		return depth
	}
}
