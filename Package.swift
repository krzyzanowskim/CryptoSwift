// swift-tools-version:5.6

import PackageDescription

let resources: [Resource]?
let exclude: [String]

let privacyInfoName = "PrivacyInfo.xcprivacy" 

// Only copy resources on Apple platforms.
// While it might seem innocent to include the resource on non-Apple platforms
// it actually causes Swift to automatically link to Foundation even if no explicit
// `import Foundation` is in any of the swift files.
// Maybe there's a better way to exclude the resources depending on the target platform
// but unfortunately I haven't found one.
#if canImport(Darwin)
resources = [.copy(privacyInfoName)]
exclude = []
#else
resources = nil
exclude = [ privacyInfoName ]
#endif

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
    .target(name: "CryptoSwift", exclude: exclude, resources: resources),
    .testTarget(name: "CryptoSwiftTests", dependencies: ["CryptoSwift"])
  ],
  swiftLanguageVersions: [.v5]
)
