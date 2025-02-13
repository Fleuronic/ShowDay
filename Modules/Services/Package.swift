// swift-tools-version:6.2
import PackageDescription

let package = Package(
	name: "Services",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "DrumCorpsAPI",
			targets: ["DrumCorpsAPI"]
		),
		.library(
			name: "DrumCorpsDatabase",
			targets: ["DrumCorpsDatabase"]
		),
		.library(
			name: "DrumCorpsService",
			targets: ["DrumCorpsService"]
		)
	],
	dependencies: [
		.package(path: "../Models"),
		.package(url: "https://github.com/jordanekay/workflow-swift", branch: "main"),
		.package(url: "https://github.com/Fleuronic/DrumKitAPI", branch: "main"),
		.package(url: "https://github.com/Fleuronic/DrumKitDatabase", branch: "main")
	],
	targets: [
		.target(
			name: "DrumCorpsAPI",
			dependencies: ["DrumCorpsService"],
			path: "Sources/DrumCorps/Clients/API"
		),
		.target(
			name: "DrumCorpsDatabase",
			dependencies: [
				"DrumKitDatabase",
				"DrumCorpsService"
			],
			path: "Sources/DrumCorps/Clients/Database"
		),
		.target(
			name: "DrumCorpsService",
			dependencies: [
				"DrumKitAPI", // ?
				.product(name: "DrumCorps", package: "Models"),
				.product(name: "WorkflowReactiveSwift", package: "workflow-swift")
			],
			path: "Sources/DrumCorps/Service"
		)
	],
	swiftLanguageModes: [.v6]
)

for target in package.targets {
	target.swiftSettings = [
		.enableExperimentalFeature("StrictConcurrency"),
		.enableUpcomingFeature("ExistentialAny"),
		.enableUpcomingFeature("InternalImportsByDefault")
	]
}
