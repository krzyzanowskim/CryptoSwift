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
    .target(name: "CryptoSwift", resources: [.copy("PrivacyInfo.xcprivacy")]),
    .testTarget(name: "CryptoSwiftTests", dependencies: ["CryptoSwift"])
  ],
  swiftLanguageVersions: [.v5]
)

#if swift(>=5.6)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.3.0")
  )
#endif
