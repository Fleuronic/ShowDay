// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import struct RESTAPI.API
private import struct Speaker.Speaker
private import struct QuestionBankAPI.API

@testable private import struct Root.Root

final class RootTests: XCTestCase {}

// MARK: -
extension RootTests {
	func testRoot() {
		let root = MockRoot()
		XCTAssertNotNil(root)
	}
}

// MARK: -
private extension RootTests {
	typealias MockRoot = Root<MockAPI, Speaker, Speaker>
	typealias MockAPI = API<QuestionEndpointsMock>
}
