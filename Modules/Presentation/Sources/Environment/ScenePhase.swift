// Copyright © Fleuronic LLC. All rights reserved.

public import SwiftUI
public import ViewEnvironment

public extension ViewEnvironment {
	var scenePhase: ScenePhase {
		get { self[ScenePhaseKey.self] }
		set { self[ScenePhaseKey.self] = newValue }
	}
}

// MARK: -
private enum ScenePhaseKey: ViewEnvironmentKey {
	static var defaultValue: ScenePhase { .active }
}
