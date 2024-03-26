// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesScratchHandler",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SmilesScratchHandler",
            targets: ["SmilesScratchHandler"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../SmilesUtilities"),
        .package(path: "../SmilesFontsManager"),
        .package(path: "../SmilesLanguageManager"),
        .package(path: "../SmilesBaseMainRequestManager"),
        .package(path: "../NetworkingLayer"),
        .package(path: "../SmilesLoader")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SmilesScratchHandler",
            dependencies: [
                .product(name: "SmilesLanguageManager", package: "SmilesLanguageManager"),
                .product(name: "SmilesFontsManager", package: "SmilesFontsManager"),
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "SmilesBaseMainRequestManager", package: "SmilesBaseMainRequestManager"),
                .product(name: "NetworkingLayer", package: "NetworkingLayer"),
                .product(name: "SmilesLoader", package: "SmilesLoader")
            ],
        path: "Sources")
    ]
)
