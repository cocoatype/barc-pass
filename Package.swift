// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "barc-pass",
    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17)],
    products: [
        .executable(name: "BarcPass", targets: ["BarcPass"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "4.0.0"),
    ],
    targets: [
        .executableTarget(name: "BarcPass",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "Crypto", package: "swift-crypto"),
            ],
            path: "Sources/App"
        ),
        .testTarget(name: "BarcPassTests",
            dependencies: [
                .byName(name: "BarcPass"),
                .product(name: "HummingbirdTesting", package: "hummingbird")
            ],
            path: "Tests/AppTests"
        )
    ]
)
