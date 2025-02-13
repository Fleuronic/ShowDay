// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import ViewInspector
private import struct Speaker.Speaker
private import struct QuestionBankAPI.API
private import struct RESTAPI.API

@testable private import WorkflowSwiftUI
@testable private import struct Root.Root
@testable private import struct Root.RootViewPreviews
@testable private import struct TextToSpeech.TextToSpeech

final class RootViewTests: XCTestCase {}

extension RootViewTests {
	func testView() {
		let screen = Screen(
			accessor: .constant(state: .init()),
			textToSpeechScreen: .init(
				accessor: .constant(state: .init()),
				voiceListScreen: .init(
					accessor: .constant(state: .init(voices: [])),
					sink: .init { _ in }
				),
				samplePlayerScreen: nil,
				sink: .init { _ in }
			)
		)

		let (store, _) = Store<Screen>.make(model: screen.model)
		let view = View(store: store)

		XCTAssertNotNil(view)
	}

	@MainActor
	func testPreviews() {
		let previews = RootViewPreviews.previews
		ViewHosting.host(view: previews)
		XCTAssertNotNil(previews)
	}
}

// MARK: -
private extension RootViewTests {
	typealias Screen = MockRoot.Screen
	typealias View = MockRoot.View
	typealias MockRoot = Root<MockAPI, Speaker, Speaker>
	typealias MockAPI = API<QuestionEndpointsMock>
}
