// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import Metrics

@testable private import struct Metric.Size

final class SizeTests: XCTestCase {}

// MARK: -
extension SizeTests {
	func testValues() {
		XCTAssertEqual(Size.Width.button.value, 40)
		XCTAssertEqual(Size.Height.button.value, 40)
	}
}
