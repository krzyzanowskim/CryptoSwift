// swift-tools-version:5.6

import PackageDescription

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
    .target(
      name: "CryptoSwift", 
      resources: [.copy("PrivacyInfo.xcprivacy")],
      swiftSettings: [.unsafeFlags(["-enable-library-evolution"])]
    ),
    .testTarget(name: "CryptoSwiftTests", dependencies: ["CryptoSwift"])
  ],
  swiftLanguageVersions: [.v5]
)
