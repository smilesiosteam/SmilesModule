// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesOnboarding",
    platforms: [
        .iOS(.v14)
    ], products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SmilesOnboarding",
            targets: ["SmilesOnboarding"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../SmilesBaseMainRequestManager"),
        .package(path: "../NetworkingLayer"),
        .package(path: "../SmilesLoader"),
        .package(path: "../SmilesLanguageManager"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.6.0"),
        .package(path: "../LottieAnimationManager"),
        .package(path: "../SmilesFontsManager"),
        .package(path: "../DeviceAppCheck"),
        .package(path: "../SmilesLocationHandler")
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SmilesOnboarding",
            dependencies: [
                .product(name: "SmilesBaseMainRequestManager", package: "SmilesBaseMainRequestManager"),
                .product(name: "NetworkingLayer", package: "NetworkingLayer"),
                .product(name: "SmilesLoader", package: "SmilesLoader"),
                .product(name: "SmilesLanguageManager", package: "SmilesLanguageManager"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
                .product(name: "LottieAnimationManager", package: "LottieAnimationManager"),
                .product(name: "SmilesFontsManager", package: "SmilesFontsManager"),
                .product(name: "DeviceAppCheck", package: "DeviceAppCheck"),
                .product(name: "SmilesLocationHandler", package: "SmilesLocationHandler")
            ],
            path: "Sources",
            resources: [.process("Resources")]),
        .testTarget(
            name: "SmilesOnboardingTests",
            dependencies: ["SmilesOnboarding"]),
    ]
)
