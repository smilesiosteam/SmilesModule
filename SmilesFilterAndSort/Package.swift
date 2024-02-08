// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesFilterAndSort",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SmilesFilterAndSort",
            targets: ["SmilesFilterAndSort"]),
    ], 
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../SmilesUtilities"),
        .package(path: "../SmilesFontsManager"),
        .package(path: "../NetworkingLayer"),
        .package(path: "../SmilesOffers")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SmilesFilterAndSort",
            dependencies: [
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "SmilesFontsManager", package: "SmilesFontsManager"),
                .product(name: "NetworkingLayer", package: "NetworkingLayer"),
                .product(name: "SmilesOffers", package: "SmilesOffers")
            ],
            resources: [
                .copy("Models/Mock/FilterDataModel.json"),
                .copy("Models/Mock/OffersFilterResponse.json")
            ]
        ),
    ]
)
