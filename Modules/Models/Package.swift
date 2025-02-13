// swift-tools-version:6.2
import PackageDescription

let package = Package(
	name: "Models",
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	products: [
		.library(
			name: "DrumCorps",
			targets: ["DrumCorps"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/Fleuronic/DrumKitService", branch: "main"),
		.package(url: "https://github.com/gohanlon/swift-memberwise-init-macro", from: "0.5.0"),
	],
	targets: [
		.target(
			name: "DrumCorps",
			dependencies: [
				"DrumKitService",
				.product(name: "MemberwiseInit", package: "swift-memberwise-init-macro"),
			]
		)
	],
	swiftLanguageModes: [.v6],
)

for target in package.targets {
	target.swiftSettings = [
		.enableExperimentalFeature("StrictConcurrency"),
		.enableUpcomingFeature("ExistentialAny"),
		.enableUpcomingFeature("InternalImportsByDefault"),
	]
}
