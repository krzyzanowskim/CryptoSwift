// swift-tools-version:5.3

import PackageDescription

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
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
        url: "https://github.com/krzyzanowskim/CryptoSwift/releases/download/1.3.5/CryptoSwift.xcframework.zip",
        checksum: "6368602213b62cc8d5ec2f12ee0b593fdb963cb1b0c30ea98af4a14689fd601a"
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
