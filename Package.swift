// swift-tools-version:5.6

import PackageDescription

let applePlatforms: [Platform] = [
  .iOS,
  .macOS,
  .tvOS,
  .watchOS,
  .macCatalyst,
  .custom("visionos")
]

let package = Package(
  name: "CryptoSwift",
  platforms: [
    .macOS(.v10_13), .macCatalyst(.v13), .iOS(.v11), .tvOS(.v11), .watchOS(.v4), .custom("visionos", versionString: "1.0")
  ],
  products: [
    .library(
      name: "CryptoSwift",
      targets: ["CryptoSwift"]
    )
  ],
  targets: [
    // Keep the privacy manifest out of non-Apple builds so SwiftPM doesn't pull in
    // Foundation just to synthesize a resource bundle accessor.
    .target(name: "CryptoSwiftResources", resources: [.copy("PrivacyInfo.xcprivacy")]),
    .target(
      name: "CryptoSwift",
      dependencies: [
        .target(name: "CryptoSwiftResources", condition: .when(platforms: applePlatforms))
      ]
    ),
    .testTarget(name: "CryptoSwiftTests", dependencies: ["CryptoSwift"])
  ],
  swiftLanguageVersions: [.v5]
)
