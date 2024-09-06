# Swift Bijective Dictionary

[![Supported Swift versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fladvoc%2FBijectiveDictionary%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ladvoc/BijectiveDictionary)
[![Supported swift platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fladvoc%2FBijectiveDictionary%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ladvoc/BijectiveDictionary)

A bijective dictionary is a specialized dictionary that offers efficient bidirectional access in O(1) time, making it ideal for scenarios where the performance of reverse lookups is a key consideration. However,
this comes at the cost of increased memory usage.

[Documentation »](https://swiftpackageindex.com/ladvoc/BijectiveDictionary/main/documentation/bijectivedictionary)

## Basic Usage

Bijective dictionary closely mirrors the standard dictionary type from the standard library,
sharing many of the same initializers, methods, and properties. The key distinction lies in its
ability to access elements bidirectionally. In a bijective dictionary, keys and values are referred
to as “left values” and “right values” respectively, to avoid confusion, since either can be used
to access the other.

The following example demonstrates creating a bijective dictionary from a dictionary literal
that maps IANA time zones to their corresponding UTC offsets (not considering daylight savings time):

```swift
var timeZones: BijectiveDictionary = [
    "America/Los_Angeles": -8,
    "Europe/London": 0
    "Europe/Kiev": 2,
    "Asia/Singapore": 8
]
```

With the dictionary constructed, an entry in `timeZones` can be accessed either by its left
value (time zone) or right value (UTC offset):

```swift
print(timeZones[left: "America/Los_Angeles"]) // prints -8
print(timeZones[right: 2]) // prints "Europe/Kiev"
```

The same subscripts can also be used to set values when the dictionary is mutable:

```swift
timeZones[left: "Asia/Seoul"] = 9
timeZones[right: -9] = "America/Anchorage"
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
            url: "https://github.com/ladvoc/BijectiveDictionary.git",
            .upToNextMinor(from: "0.1.0")
        )
    ],
    targets: [
        .target(
            name: "MyTarget",
            dependencies: [
                .product(name: "BijectiveDictionary", package: "BijectiveDictionary")
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
