// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import SwiftUI
private import Environment
private import ViewEnvironment

final class ScenePhaseTests: XCTestCase {}

// MARK:
extension ScenePhaseTests {
	func testDefaultValue() {
		let defaultValue = ScenePhase.active
		let environment = ViewEnvironment.empty

		XCTAssertEqual(environment.scenePhase, defaultValue)
	}

	func testSettingValue() {
		let scenePhase = ScenePhase.inactive
		let environment = ViewEnvironment.empty
			.setting(keyPath: \.scenePhase, to: scenePhase)

		XCTAssertEqual(environment.scenePhase, scenePhase)
	}
}
