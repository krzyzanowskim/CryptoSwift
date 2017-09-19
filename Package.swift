// swift-tools-version:4.0

import PackageDescription

let _ = Package(name: "CryptoSwift", products: [.library(name: "CryptoSwift", targets: ["CryptoSwift"])],
              targets: [
                  .target(name:"CryptoSwift"),
                  .testTarget(name:"CryptoSwiftTests",dependencies:["CryptoSwift"])
              ],
              swiftLanguageVersions: [4])