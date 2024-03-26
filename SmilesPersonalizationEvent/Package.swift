// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesPersonalizationEvent",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SmilesPersonalizationEvent",
            targets: ["SmilesPersonalizationEvent"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../SmilesUtilities"),
        .package(path: "../NetworkingLayer")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SmilesPersonalizationEvent",
            dependencies: [
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "NetworkingLayer", package: "NetworkingLayer")
            ],
        path: "sources"),
        .testTarget(
            name: "SmilesPersonalizationEventTests",
            dependencies: ["SmilesPersonalizationEvent"]),
    ]
)
