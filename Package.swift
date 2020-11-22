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
        url: "https://github.com/krzyzanowskim/CryptoSwift/releases/download/1.3.6/CryptoSwift.xcframework.zip",
        checksum: "555f8e141dacb9f5a1635d7a5afa6cbee62709f3dba13f799c84e62339c2a2a8"
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
