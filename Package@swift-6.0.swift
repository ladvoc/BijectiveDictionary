// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BijectiveDictionary",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "BijectiveDictionary",
            targets: ["BijectiveDictionary"])
    ],
    targets: [
        .target(
            name: "BijectiveDictionary"
        ),
        .testTarget(
            name: "BijectiveDictionaryTests",
            dependencies: ["BijectiveDictionary"]
        ),
    ],
    swiftLanguageVersions: [.v6]
)
