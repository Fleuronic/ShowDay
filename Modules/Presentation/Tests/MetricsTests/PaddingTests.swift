// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import Metrics

@testable private import struct Metric.Padding

final class PaddingTests: XCTestCase {}

// MARK: -
extension PaddingTests {
	func testValues() {
		XCTAssertEqual(Padding.element.value, 32)
	}
}
