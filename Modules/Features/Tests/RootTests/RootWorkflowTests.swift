// Copyright © Fleuronic LLC. All rights reserved.

import XCTest

private import WorkflowTesting
private import ViewInspector
private import struct Speaker.Speaker
private import struct QuestionBankAPI.API
private import struct RESTAPI.API

@testable private import struct Root.Root
@testable private import struct TextToSpeech.TextToSpeech

final class RootWorkflowTests: XCTestCase {}

extension RootWorkflowTests {
	func testRenderingScreen() {
		let api = API.mock
		let speaker = Speaker()
		let workflow = Workflow(
			loadService: api,
			speechService: speaker,
			voiceService: speaker
		)

		let textToSpeechScreen = TextToSpeechScreen(
			accessor: .constant(state: .init()),
			voiceListScreen: .init(
				accessor: .constant(state: .init(voices: [])),
				sink: .init { _ in }
			),
			samplePlayerScreen: nil,
			sink: .init { _ in }
		)

		let tester = workflow.renderTester().expectWorkflow(
			type: TextToSpeechWorkflow.self,
			producingRendering: textToSpeechScreen
		)

		tester.render { screen in
			XCTAssertNotNil(screen)
		}.verifyState { state in
			XCTAssertNotNil(state)
		}.assertNoOutput()
	}
}

// MARK: -
private extension RootWorkflowTests {
	typealias Workflow = MockRoot.Workflow
	typealias Screen = MockRoot.Screen
	typealias State = Workflow.State
	typealias TextToSpeechScreen = MockTextToSpeech.Screen
	typealias TextToSpeechWorkflow = MockTextToSpeech.Workflow
	typealias MockAPI = API<QuestionEndpointsMock>
	typealias MockRoot = Root<MockAPI, Speaker, Speaker>
	typealias MockTextToSpeech = TextToSpeech<MockAPI, Speaker, Speaker>
}
