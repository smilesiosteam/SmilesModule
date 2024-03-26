// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesOrderTracking",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SmilesOrderTracking",
            targets: ["SmilesOrderTracking"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../SmilesUtilities"),
        .package(path: "../SmilesFontsManager"),
        .package(path: "../SmilesBaseMainRequestManager"),
        .package(path: "../NetworkingLayer"),
        .package(path: "../LottieAnimationManager"),
        .package(path: "../SmilesLoader"),
        .package(path: "../SmilesScratchHandler"),
        .package(path: "../SmilesSharedServices"),
        .package(path: "../SmilesTests"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", .upToNextMajor(from: "23.0.0")),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0"),
        .package(url: "https://github.com/sabarics/PlaceholderUITextView.git", branch: "master"),
        .package(url: "https://github.com/googlemaps/ios-maps-sdk", exact: "8.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SmilesOrderTracking",
            dependencies: [
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "SmilesFontsManager", package: "SmilesFontsManager"),
                .product(name: "SmilesBaseMainRequestManager", package: "SmilesBaseMainRequestManager"),
                .product(name: "NetworkingLayer", package: "NetworkingLayer"),
                .product(name: "Cosmos", package: "Cosmos"),
                .product(name: "LottieAnimationManager", package: "LottieAnimationManager"),
                .product(name: "SmilesLoader", package: "SmilesLoader"),
                .product(name: "SDWebImage", package: "SDWebImage"),
                .product(name: "PlaceholderUITextView", package: "PlaceholderUITextView"),
                .product(name: "SmilesScratchHandler", package: "SmilesScratchHandler"),
                .product(name: "SmilesSharedServices", package: "SmilesSharedServices"),
                // Google
                .product(name: "GoogleMaps", package: "ios-maps-sdk"),
                .product(name: "GoogleMapsBase", package: "ios-maps-sdk"),
                .product(name: "GoogleMapsCore", package: "ios-maps-sdk")
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SmilesOrderTrackingTests",
            dependencies: ["SmilesOrderTracking", "SmilesTests"],
            resources: [.process("Resources")]
        ),
    ]
)
