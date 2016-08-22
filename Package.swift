import PackageDescription

let package = Package(name: "CryptoSwift")

package.exclude.append("Tests/CryptoSwiftTests/CommonCryptoTests.swift")
