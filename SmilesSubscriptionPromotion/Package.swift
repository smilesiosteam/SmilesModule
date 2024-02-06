// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesSubscriptionPromotion",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SmilesSubscriptionPromotion",
            targets: ["SmilesSubscriptionPromotion"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../SmilesYoutubePopUpView"),
        .package(path: "../SmilesFontsManager"),
        .package(path: "../SmilesUtilities"),
        .package(path: "../SmilesSharedServices"),
        .package(path: "../SmilesLanguageManager"),
        .package(path: "../SmilesLoader"),
        .package(path: "../SmilesBaseMainRequest"),
        .package(path: "../SmilesOffers"),
        .package(path: "../SmilesBanners"),
        .package(path: "../SmilesStoriesManager"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SmilesSubscriptionPromotion",
            dependencies: [
                .product(name: "SmilesYoutubePopUpView", package: "SmilesYoutubePopUpView"),
                .product(name: "SmilesFontsManager", package: "SmilesFontsManager"),
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "SmilesSharedServices", package: "SmilesSharedServices"),
                .product(name: "SmilesLanguageManager", package: "SmilesLanguageManager"),
                .product(name: "SmilesLoader", package: "SmilesLoader"),
                .product(name: "SmilesBaseMainRequestManager", package: "SmilesBaseMainRequest"),
                .product(name: "SmilesOffers", package: "SmilesOffers"),
                .product(name: "SmilesBanners", package: "SmilesBanners"),
                .product(name: "SmilesStoriesManager", package: "SmilesStoriesManager")
            ],
            path: "Sources",
            resources: [
                .process("Resources")
            ]),
    ]
)
