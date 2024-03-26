// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppHeader",
    platforms: [
        .iOS(.v14)
    ],products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppHeader",
            targets: ["AppHeader"]),
    ],
    dependencies: [
        .package(path: "../LottieAnimationManager"),
        .package(path: "../SmilesLocationHandler")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppHeader",
            dependencies: [
                .product(name: "LottieAnimationManager", package: "LottieAnimationManager"),
                .product(name: "SmilesLocationHandler", package: "SmilesLocationHandler")
            ],
        path: "Sources"),
        .testTarget(
            name: "AppHeaderTests",
            dependencies: ["AppHeader"]),
    ]
)
