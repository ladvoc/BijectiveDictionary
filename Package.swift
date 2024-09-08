// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "BijectiveDictionary",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "BijectiveDictionary",
            targets: ["BijectiveDictionary"])
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.56.2")
    ],
    targets: [
        .target(
            name: "BijectiveDictionary",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
        .testTarget(
            name: "BijectiveDictionaryTests",
            dependencies: ["BijectiveDictionary"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
