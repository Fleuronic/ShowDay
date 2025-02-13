// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import struct RESTAPI.API
private import struct Speaker.Speaker
private import struct SpeechSynthesis.Voice
private import struct QuestionBankAPI.API

@testable private import struct Root.Root
@testable private import struct TextToSpeech.TextToSpeech

final class RootScreenTests: XCTestCase {}

// MARK: -
extension RootScreenTests {
	func testScreen() {
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

		XCTAssertNotNil(screen)
	}
}

// MARK: -
private extension RootScreenTests {
	typealias Screen = MockRoot.Screen
	typealias MockRoot = Root<MockAPI, Speaker, Speaker>
	typealias MockAPI = API<QuestionEndpointsMock>
}
