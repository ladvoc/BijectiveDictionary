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
        .package(url: "https://github.com/apple/swift-collections-benchmark", from: "0.0.3"),
    ],
    targets: [
        .target(
            name: "BijectiveDictionary",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "BijectiveDictionaryTests",
            dependencies: ["BijectiveDictionary"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .executableTarget(
            name: "BijectiveDictionaryBenchmark",
            dependencies: [
                "BijectiveDictionary",
                .product(name: "CollectionsBenchmark", package: "swift-collections-benchmark"),
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
