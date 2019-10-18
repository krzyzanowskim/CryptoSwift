// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "CryptoSwift",
  platforms: [
    .macOS(.v10_10), .iOS(.v8), .tvOS(.v9)
  ],
  products: [
    .library(
      name: "CryptoSwift",
      targets: ["CryptoSwift"]
    )
  ],
  targets: [
    .target(name: "CryptoSwift"),
    .testTarget(name: "CryptoSwiftTests", dependencies: ["CryptoSwift"]),
    .testTarget(name: "TestsPerformance", dependencies: ["CryptoSwift"])
  ],
  swiftLanguageVersions: [.v5]
)
