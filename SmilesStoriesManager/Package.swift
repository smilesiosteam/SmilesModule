// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesStoriesManager",
    platforms: [
        .iOS(.v14)
    ], products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SmilesStoriesManager",
            targets: ["SmilesStoriesManager"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../SmilesBaseMainRequestManager"),
        .package(path: "../NetworkingLayer"),
        .package(path: "../SmilesLoader"),
        .package(path: "../SmilesLanguageManager"),
        .package(path: "../SmilesFontsManager"),
        .package(path: "../LottieAnimationManager"),
        .package(path: "../SmilesUtilities"),
        .package(path: "../SmilesSharedServices")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SmilesStoriesManager",
            dependencies: [
                .product(name: "SmilesBaseMainRequestManager", package: "SmilesBaseMainRequestManager"),
                .product(name: "NetworkingLayer", package: "NetworkingLayer"),
                .product(name: "SmilesLoader", package: "SmilesLoader"),
                .product(name: "SmilesLanguageManager", package: "SmilesLanguageManager"),
                .product(name: "SmilesFontsManager", package: "SmilesFontsManager"),
                .product(name: "LottieAnimationManager", package: "LottieAnimationManager"),
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "SmilesSharedServices", package: "SmilesSharedServices")
            ],
            resources: [.copy("Stories.json")]),
        .testTarget(
            name: "SmilesStoriesManagerTests",
            dependencies: [
                "SmilesStoriesManager",
                .product(name: "SmilesUtilities", package: "SmilesUtilities")
            ]),
    ]
)
