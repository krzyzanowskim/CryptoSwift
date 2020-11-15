// swift-tools-version:5.3

import PackageDescription

#if os(macOS)
let package = Package(
  name: "CryptoSwift",
  platforms: [
    .macOS(.v10_12), .iOS(.v9), .tvOS(.v9)
  ],
  products: [
    .library(
      name: "CryptoSwift",
      targets: ["CryptoSwift"]
    )
  ],
  targets: [
    .binaryTarget(
        name: "CryptoSwift",
        url: "https://github.com/krzyzanowskim/CryptoSwift/releases/download/1.3.4/CryptoSwift.xcframework.zip",
        checksum: "0072dd9a3bd76f0bf4922ad88424fcff8301502446e550a8f6c86c63692b7592"
    ),
    .testTarget(name: "TestsPerformance", dependencies: ["CryptoSwift"])
  ]
)
#else
let package = Package(
  name: "CryptoSwift",
  platforms: [
    .macOS(.v10_12), .iOS(.v9), .tvOS(.v9)
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
#endif
