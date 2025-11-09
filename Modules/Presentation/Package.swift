// swift-tools-version:6.2
import PackageDescription

let package = Package(
	name: "Presentation",
	platforms: [
		.iOS(.v17),
		.macOS(.v15)
	],
	products: [
		.library(
			name: "Presentation",
			targets: [
				"Metrics",
				"Assets",
				"Elements",
				"Environment"
			]
		)
	],
	dependencies: [
		.package(url: "https://github.com/jordanekay/Metric", branch: "main"),
		.package(url: "https://github.com/jordanekay/workflow-swift", branch: "main")
	],
	targets: [
		.target(
			name: "Metrics",
			dependencies: ["Metric"]
		),
		.testTarget(
			name: "MetricsTests",
			dependencies: ["Metrics"]
		),
		.target(name: "Assets"),
		.target(
			name: "Elements",
			dependencies: ["Assets"]
		),
		.target(
			name: "Environment",
			dependencies: [.product(name: "ViewEnvironment", package: "workflow-swift")]
		),
		.testTarget(
			name: "EnvironmentTests",
			dependencies: ["Environment"]
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
