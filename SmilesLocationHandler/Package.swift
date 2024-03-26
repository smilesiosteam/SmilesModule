// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesLocationHandler",
    platforms: [
        .iOS(.v14)
    ], products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SmilesLocationHandler",
            targets: ["SmilesLocationHandler"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../SmilesEasyTipView"),
        .package(path: "../SmilesUtilities"),
        .package(path: "../NetworkingLayer"),
        .package(path: "../SmilesAnalytics"),
        .package(path: "../SmilesBaseMainRequestManager"),
        .package(path: "../SmilesLanguageManager"),
        .package(path: "../SmilesLoader"),
        .package(url: "https://github.com/googlemaps/ios-maps-sdk", exact: "8.4.0"),
        .package(url: "https://github.com/googlemaps/ios-places-sdk", from: "8.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SmilesLocationHandler",
            dependencies: [
                .product(name: "SmilesEasyTipView", package: "SmilesEasyTipView"),
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "NetworkingLayer", package: "NetworkingLayer"),
                .product(name: "AnalyticsSmiles", package: "SmilesAnalytics"),
                .product(name: "SmilesBaseMainRequestManager", package: "SmilesBaseMainRequestManager"),
                .product(name: "SmilesLanguageManager", package: "SmilesLanguageManager"),
                .product(name: "SmilesLoader", package: "SmilesLoader"),
                // Google
                .product(name: "GoogleMaps", package: "ios-maps-sdk"),
                .product(name: "GoogleMapsBase", package: "ios-maps-sdk"),
                .product(name: "GoogleMapsCore", package: "ios-maps-sdk"),
                .product(name: "GooglePlaces", package: "ios-places-sdk")
            ],
            path: "Sources/SmilesLocationHandler",
            resources: [
                .process("Resources")
            ])
    ]
)
