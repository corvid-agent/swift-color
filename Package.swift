// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-color",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "Color", targets: ["Color"])
    ],
    targets: [
        .target(name: "Color"),
        .testTarget(
            name: "ColorTests",
            dependencies: ["Color"]
        )
    ]
)
