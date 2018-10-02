// swift-tools-version:4.0

import PackageDescription

_ = Package(name: "CryptoSwift",
            products: [.library(name: "CryptoSwift", targets: ["CryptoSwift"])],
            targets: [
                .target(name: "CryptoSwift"),
                .testTarget(name: "Tests", dependencies: ["CryptoSwift"]),
                .testTarget(name: "TestsPerformance", dependencies: ["CryptoSwift"]),
            ],
            swiftLanguageVersions: [4])
