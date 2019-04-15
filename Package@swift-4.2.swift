// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "CryptoSwift",
    products: [
        .library(
            name: "CryptoSwift",
            targets: ["CryptoSwift"])
    ],
    targets: [
        .target(name: "CryptoSwift"),
        .testTarget(name: "Tests", dependencies: ["CryptoSwift"]),
        .testTarget(name: "TestsPerformance", dependencies: ["CryptoSwift"]),
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
