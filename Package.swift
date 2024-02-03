// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
 
let package = Package(
    name: "SmilesMonoRepo",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .SmilesFontsManager,
        .SmilesUtilities,
        .SmilesStorage,
        .SmilesLanguageManager,
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.8.0")),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0"),
    ],
    targets: [
        .SmilesMonoRepo,
        .SmilesFontsManager,
        .SmilesStorage,
        .SmilesUtilities,
        .SmilesLanguageManager,
    ]
)


extension String {
    static let SmilesMonoRepo = "SmilesMonoRepo"
    static let SmilesFontsManager = "SmilesFontsManager"
    static let SmilesUtilities = "SmilesUtilities"
    static let SmilesStorage = "SmilesStorage"
    static let SmilesLanguageManager = "SmilesLanguageManager"

    enum Prefixed {
        static let SmilesFontsManager = "SmilesFontsManager"
        static let SmilesUtilities = "SmilesUtilities"
        static let SmilesStorage = "SmilesStorage"
        static let SmilesLanguageManager = "SmilesLanguageManager"
    }
}

extension Product {
    static let SmilesFontsManager = library(name: .SmilesFontsManager, targets: [.Prefixed.SmilesFontsManager])
    static let SmilesUtilities = library(name: .SmilesUtilities, targets: [.SmilesUtilities, .Prefixed.SmilesUtilities])
    static let SmilesStorage = library(name: .SmilesStorage, targets: [.SmilesStorage])
    static let SmilesLanguageManager = library(name: .SmilesLanguageManager, targets: [.SmilesLanguageManager, .Prefixed.SmilesLanguageManager])
}

extension Target {
   
    static let SmilesMonoRepo = target(name: .SmilesMonoRepo)
    
    static let SmilesStorage = target(name: .SmilesStorage, dependencies: [],
                                           path: "SmilesStorage/Sources/SmilesStorage/")
    
    static let SmilesLanguageManager = target(name: .SmilesLanguageManager, 
                                              dependencies: [.SmilesStorage],
                                              path: "SmilesLanguageManager/Sources/SmilesLanguageManager/")
    
    static let SmilesFontsManager = target(name: .SmilesFontsManager, dependencies: [],
                                           path: "SmilesFontsManager/Sources/SmilesFontsManager/")
    
    static let SmilesUtilities = target(name: .SmilesUtilities,
                                        dependencies: [.SmilesFontsManager, .SmilesLanguageManager, .CryptoSwift, .SkeletonView, .SDWebImage],
                                        path: "SmilesUtilities/Sources/SmilesUtilities/")
}


extension Target.Dependency {
    static let SmilesFontsManager = byName(name: .SmilesFontsManager)
    static let SmilesUtilities = byName(name: .SmilesUtilities)
    static let SmilesStorage = byName(name: .SmilesStorage)
    static let SmilesLanguageManager = byName(name: .SmilesLanguageManager)
    static let CryptoSwift = byName(name: "CryptoSwift")
    static let SkeletonView = byName(name: "SkeletonView")
    static let SDWebImage = byName(name: "SDWebImage")
}
