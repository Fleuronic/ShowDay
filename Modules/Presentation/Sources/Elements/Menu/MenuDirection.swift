private import AppKit
private import ObjectiveC

public enum MenuDirection {}

// MARK: -
public extension MenuDirection {
	static func standardize() {
		guard
			let cls = NSClassFromString("NSPopupMenuWindow"),
			case let sel = NSSelectorFromString(
				"_positionSubmenuHorizontally:withMenuWidth:inParentItemBounds:withInsets:allowingOverlap:"
			), let method = class_getInstanceMethod(cls, sel) else { return }

		let block: @convention(block) (AnyObject, Int, Double, CGRect, NSEdgeInsets, Bool) -> Double = { obj, direction, menuWidth, parentBounds, insets, allowOverlap in
			menuDepth(of: obj) < 3 ? parentBounds.minX - menuWidth : parentBounds.maxX - 300
		}

		method_setImplementation(method, imp_implementationWithBlock(block))
	}
}

// MARK: -
private extension MenuDirection {
	static func menuDepth(of window: AnyObject) -> Int {
		guard
			case let implSel = NSSelectorFromString("associatedImpl"),
			window.responds(to: implSel),
			let implResult = window.perform(implSel)?.takeUnretainedValue(),
			case let menuSel = NSSelectorFromString("menu"),
			implResult.responds(to: menuSel),
			let menu = implResult.perform(menuSel)?.takeUnretainedValue() as? NSMenu else { return 0 }

		var depth = 0
		var currentMenu: NSMenu? = menu
		while let supermenu = currentMenu?.supermenu {
			depth += 1
			currentMenu = supermenu
		}

		return depth
	}
}
