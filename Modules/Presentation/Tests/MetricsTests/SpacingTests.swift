// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import Metrics

@testable private import enum Metric.Spacing

final class SpacingTests: XCTestCase {}

// MARK: -
extension SpacingTests {
	func testValues() {
		XCTAssertEqual(Spacing.Vertical.element.value, 32)
	}
}
