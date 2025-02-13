// swift-tools-version:6.0
import PackageDescription

let package = Package(
	name: "Features",
	platforms: [
		.iOS(.v18),
		.macOS(.v15)
	],
	products: [
		.library(
			name: "Root",
			targets: ["Root"]
		),
		.library(
			name: "Calendar",
			targets: ["Calendar"]
		),
	],
	dependencies: [
		.package(name: "Models", path: "../Models"),
		.package(name: "Services", path: "../Services"),
		.package(name: "Presentation", path: "../Presentation"),
		.package(url: "https://github.com/Fleuronic/ErgoAppKit", branch: "main"),
		.package(url: "https://github.com/jordanekay/workflow-swift", branch: "main"),
		.package(url: "https://github.com/sparrowcode/SafeSFSymbols", branch: "main"),
		.package(url: "https://github.com/nalexn/ViewInspector", branch: "0.10.2")
	],
	targets: [
		.target(
			name: "Root",
			dependencies: [
				"Calendar",
				"SafeSFSymbols"
			]
		),
		.testTarget(
			name: "RootTests",
			dependencies: [
				"Root",
				"ViewInspector",
				.product(name: "WorkflowTesting", package: "workflow-swift")
			]
		),
		.target(
			name: "Calendar",
			dependencies: [
				"Presentation",
				"ErgoAppKit",
				.product(name: "DrumCorps", package: "Models"),
				.product(name: "DrumCorpsAPI", package: "Services"),
				.product(name: "DrumCorpsDatabase", package: "Services"),
				.product(name: "DrumCorpsService", package: "Services"),
				.product(name: "WorkflowContainers", package: "workflow-swift")
			]
		),
		.testTarget(
			name: "CalendarTests",
			dependencies: [
				"Calendar",
				"ViewInspector",
				.product(name: "WorkflowTesting", package: "workflow-swift")
			]
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
