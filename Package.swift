// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "CryptoSwift",
  platforms: [
    .macOS(.v10_12), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
  ],
  products: [
    .library(
      name: "CryptoSwift",
      targets: ["CryptoSwift"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/attaswift/BigInt.git", from: "5.2.1")
  ],
  targets: [
    .target(name: "CryptoSwift", dependencies: ["BigInt"]),
    .testTarget(name: "CryptoSwiftTests", dependencies: ["CryptoSwift"]),
    .testTarget(name: "TestsPerformance", dependencies: ["CryptoSwift"])
  ],
  swiftLanguageVersions: [.v5]
)
