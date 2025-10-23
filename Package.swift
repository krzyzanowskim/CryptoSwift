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
    .target(name: "CryptoSwiftResources", resources: [ Resource.copy("PrivacyInfo.xcprivacy") ]),
    .target(name: "CryptoSwift",
            dependencies: [ .target(name: "CryptoSwiftResources", condition: .when(platforms: [ .iOS, .macOS, .tvOS, .watchOS, .macCatalyst, .visionOS ])) ]),
    .testTarget(name: "CryptoSwiftTests", dependencies: ["CryptoSwift"])
  ],
  swiftLanguageVersions: [.v5]
)
