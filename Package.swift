import PackageDescription

let package = Package(name: "CryptoSwift")

// Do not build Foundation part for non-darwin systems
// where Swift Foundation is outdated on incomplete
// see https://github.com/apple/swift/blob/master/lib/Basic/LangOptions.cpp#L26
#if !os(OSX) && !os(tvOS) && !os(iOS) && !os(watchOS)
package.exclude.append("Sources/CryptoSwift/Foundation")
#endif