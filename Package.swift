import PackageDescription

let package = Package(
    name: "CryptoSwift",
    targets: [
                Target(
                    name: "CryptoSwiftTests",
                    dependencies: [.Target(name: "CryptoSwift")]),
                 Target(
                    name: "CryptoSwift")
    ]
)