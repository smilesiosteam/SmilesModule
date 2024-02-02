// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesUtilities",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SmilesUtilities",
            targets: ["SmilesUtilities"]),
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.8.0")),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0"),
        .package(path: "../SmilesLanguageManager"),
        .package(path: "../SmilesFontsManager"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SmilesUtilities",
            dependencies: ["SmilesLanguageManager","SmilesFontsManager","CryptoSwift", "SkeletonView","SDWebImage"
//                .product(name: "CryptoSwift", package: "CryptoSwift"),
//                .product(name: "SkeletonView", package: "SkeletonView"),
//                .product(name: "SDWebImage", package: "SDWebImage"),
            ],
            path: "Sources/SmilesUtilities"),
        .testTarget(
            name: "SmilesUtilitiesTests",
            dependencies: ["SmilesUtilities"]),
    ]
)
