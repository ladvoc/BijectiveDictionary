// swift-tools-version: 6.0
import PackageDescription

var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.3"),
]
var plugins: [Target.PluginUsage]?

#if os(macOS)
dependencies += [.package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.56.2")]
plugins = [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
#endif

let package = Package(
    name: "BijectiveDictionary",
    platforms: [.macOS(.v12), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "BijectiveDictionary",
            targets: ["BijectiveDictionary"])
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "BijectiveDictionary",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
            ],
            plugins: plugins
        ),
        .testTarget(
            name: "BijectiveDictionaryTests",
            dependencies: ["BijectiveDictionary"],
            plugins: plugins
        ),
    ],
    swiftLanguageVersions: [.v6]
)
