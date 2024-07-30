# Swift Bijective Dictionary

[![Supported Swift versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fladvoc%2FBijectiveDictionary%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ladvoc/BijectiveDictionary)
[![Supported swift platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fladvoc%2FBijectiveDictionary%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ladvoc/BijectiveDictionary)

A bijective dictionary is like a standard dictionary but offers bidirectional O(1) access
at the cost of increased memory usage. This is useful in situations where time efficiency of reverse lookups is a key consideration.

## Simple Example

`BijectiveDictionary`'s API is designed to closely resemble that of `Dictionary` from the standard library. The follow demonstrates creating a bijective dictionary from a dictionary literal which maps time zones to their corresponding UTC offsets:

```swift
import BijectiveDictionary

let timeZones: BijectiveDictionary = [
    "America/Los_Angeles": -8,
    "Europe/London": 0
    "Europe/Kiev": 2,
    "Asia/Singapore": 8
]
```

An entry in `timeZones` can be accessed either by its left value (time zone) or right value (UTC offset):

```swift
print(timeZones[left: "America/Los_Angeles"]) // prints -8
print(timeZones[right: 2]) // prints "Europe/Kiev"
```

## Installation

Add BijectiveDictionary as a package dependency in your project's package manifest:

```swift
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(
            url: "https://github.com/ladvoc/swift-bijective-dictionary.git",
            .upToNextMinor(from: "0.1.0")
        )
    ],
    targets: [
        .target(
            name: "MyTarget",
            dependencies: [
                .product(name: "BijectiveDictionary", package: "swift-bijective-dictionary")
            ]
        )
    ]
)
```

## Project Status

The project is in an early development phase, with the current version being 0.1.0. At this point, all basic functionality is implemented and tested. However, the following tasks should be completed prior to the v1.0 release:

- [ ] **Documentation**: Ensure accuracy and completeness of documentation and include code examples.
- [ ] **Additional Methods**: Implement additional useful methods.
- [ ] **Performance Benchmarks**: Provide detailed benchmarks and performance data.

Your contributions are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE file](/LICENSE) for details.
