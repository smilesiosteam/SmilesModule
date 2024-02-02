// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
 
let package = Package(
    name: "SmilesMonoRepo",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "SmilesMonoRepo",
                 targets: [
                    "SmilesFontsManager",
                    "SmilesUtilities",
                    "SmilesStorage",
                    "SmilesLanguageManager",
                 ]),
    ],
//    dependencies: [
//        .package(name: "SmilesFontsManager", path: "SmilesFontsManager")
//    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "SmilesMonoRepo"),
        .target(name: "SmilesFontsManager", dependencies: [], path: "SmilesFontsManager/Sources/SmilesFontsManager/"),
        .target(name: "SmilesUtilities", 
                dependencies: ["SmilesLanguageManager",], path: "SmilesUtilities/Sources/SmilesUtilities/"),
        .target(name: "SmilesStorage", dependencies: [], path: "SmilesStorage/Sources/SmilesStorage/"),
        .target(name: "SmilesLanguageManager",
                dependencies: ["SmilesStorage", "SmilesFontsManager"],
                path: "SmilesLanguageManager/Sources/SmilesLanguageManager/"),
    ]
)
