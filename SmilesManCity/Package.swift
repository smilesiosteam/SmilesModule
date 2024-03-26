// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesManCity",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SmilesManCity",
            targets: ["SmilesManCity"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url:"https://github.com/youtube/youtube-ios-player-helper.git", from: "1.0.4"),
        .package(path: "../SmilesFontsManager"),
        .package(path: "../SmilesUtilities"),
        .package(path: "../SmilesSharedServices"),
        .package(path: "../SmilesLocationHandler"),
        .package(path: "../SmilesLanguageManager"),
        .package(path: "../SmilesLoader"),
        .package(path: "../SmilesBaseMainRequestManager"),
        .package(path: "../SmilesOffers"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.6.0"),
        .package(path: "../SmilesStoriesManager"),
        .package(path: "../SmilesBanners"),
        .package(path: "../SmilesReusableComponents"),
        .package(path: "../SmilesAppHeader")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SmilesManCity",
            dependencies: [
                .product(name: "YouTubeiOSPlayerHelper", package: "youtube-ios-player-helper"),
                .product(name: "SmilesFontsManager", package: "SmilesFontsManager"),
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "SmilesSharedServices", package: "SmilesSharedServices"),
                .product(name: "SmilesLocationHandler", package: "SmilesLocationHandler"),
                .product(name: "SmilesLanguageManager", package: "SmilesLanguageManager"),
                .product(name: "SmilesLoader", package: "SmilesLoader"),
                .product(name: "SmilesBaseMainRequestManager", package: "SmilesBaseMainRequestManager"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
                .product(name: "SmilesOffers", package: "SmilesOffers"),
                .product(name: "SmilesStoriesManager", package: "SmilesStoriesManager"),
                .product(name: "SmilesBanners", package: "SmilesBanners"),
                .product(name: "SmilesReusableComponents", package: "SmilesReusableComponents"),
                .product(name: "AppHeader", package: "SmilesAppHeader")
            ],
            resources: [
                .process("Resources")
            ])
    ]
)
