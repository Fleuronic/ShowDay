// Copyright © Fleuronic LLC. All rights reserved.

public import SwiftUI
public import ViewEnvironment

public extension ViewEnvironment {
	var horizontalSizeClass: UserInterfaceSizeClass {
		get { self[HorizontalSizeClassKey.self] }
		set { self[HorizontalSizeClassKey.self] = newValue }
	}

	var verticalSizeClass: UserInterfaceSizeClass {
		get { self[VerticalSizeClassKey.self] }
		set { self[VerticalSizeClassKey.self] = newValue }
	}
}

// MARK: -
private enum HorizontalSizeClassKey: ViewEnvironmentKey {
	static var defaultValue: UserInterfaceSizeClass { .regular }
}

// MARK: -
private enum VerticalSizeClassKey: ViewEnvironmentKey {
	static var defaultValue: UserInterfaceSizeClass { .regular }
}
