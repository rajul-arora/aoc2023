// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aoc2023",
    platforms: [.macOS("13.0")],
    dependencies: [
    // other dependencies
        .package(
            url: "https://github.com/apple/swift-argument-parser", 
            from: "1.2.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "aoc2023",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
    ]
)
