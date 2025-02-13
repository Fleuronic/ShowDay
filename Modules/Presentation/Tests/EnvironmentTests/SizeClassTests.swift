// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import SwiftUI
private import ViewEnvironment

final class SizeClassTests: XCTestCase {}

// MARK:
extension SizeClassTests {
	func testDefaultValue() {
		let defaultValue = UserInterfaceSizeClass.regular
		let environment = ViewEnvironment.empty

		XCTAssertEqual(environment.horizontalSizeClass, defaultValue)
		XCTAssertEqual(environment.verticalSizeClass, defaultValue)
	}

	func testSettingValue() {
		let sizeClass = UserInterfaceSizeClass.compact
		let environment = ViewEnvironment.empty
			.setting(keyPath: \.horizontalSizeClass, to: sizeClass)
			.setting(keyPath: \.verticalSizeClass, to: sizeClass)

		XCTAssertEqual(environment.horizontalSizeClass, sizeClass)
		XCTAssertEqual(environment.verticalSizeClass, sizeClass)
	}
}
