// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import Metrics

@testable private import enum Metric.Line

final class TextTests: XCTestCase {}

// MARK: -
extension TextTests {
	func testValues() {
		XCTAssertEqual(Line.Spacing.body.value, 2)
	}
}
