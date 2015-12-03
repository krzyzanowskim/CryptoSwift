import PackageDescription

let package = Package(
    name: "CryptoSwift",
    targets: [
        Target(
            name: "foo"
        )
    ],
    dependencies: [
        .Package(url: "file:///home/parallels/Desktop/Parallels Shared Folders/Home/Devel/CryptoSwift", majorVersion: 1)
    ]
)