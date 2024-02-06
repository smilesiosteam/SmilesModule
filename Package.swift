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
        .SmilesBaseMainRequestManager,
        .NetworkingLayer,
        .SmilesEmailVerification,
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.8.0")),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0"),
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", from: "5.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.4")),
    ],
    targets: [
        .SmilesMonoRepo,
        .SmilesFontsManager,
        .SmilesStorage,
        .SmilesUtilities,
        .SmilesLoader,
        .SmilesLanguageManager,
        .SmilesBaseMainRequestManager,
        .NetworkingLayer,
        .SmilesEmailVerification,
    ]
)


extension String {
    static let SmilesMonoRepo = "SmilesMonoRepo"
    static let SmilesFontsManager = "SmilesFontsManager"
    static let SmilesUtilities = "SmilesUtilities"
    static let SmilesStorage = "SmilesStorage"
    static let SmilesLanguageManager = "SmilesLanguageManager"
    static let SmilesLoader = "SmilesLoader"
    static let NetworkingLayer = "NetworkingLayer"
    static let SmilesBaseMainRequestManager = "SmilesBaseMainRequestManager"
    static let SmilesSharedServices = "SmilesSharedServices"
    static let SmilesEmailVerification = "SmilesEmailVerification"

    enum Prefixed {
        static let SmilesFontsManager = "SmilesFontsManager"
        static let SmilesUtilities = "SmilesUtilities"
        static let SmilesStorage = "SmilesStorage"
        static let SmilesLanguageManager = "SmilesLanguageManager"
        static let SmilesLoader = "SmilesLoader"
    }
}

extension Product {
    static let SmilesFontsManager = library(name: .SmilesFontsManager, targets: [.Prefixed.SmilesFontsManager])
    static let SmilesUtilities = library(name: .SmilesUtilities, targets: [.SmilesUtilities, .Prefixed.SmilesUtilities])
    static let SmilesStorage = library(name: .SmilesStorage, targets: [.SmilesStorage])
    static let SmilesLoader = library(name: .SmilesLoader, targets: [.SmilesLoader])
    static let SmilesLanguageManager = library(name: .SmilesLanguageManager, targets: [.SmilesLanguageManager, .Prefixed.SmilesLanguageManager])
    static let SmilesBaseMainRequestManager = library(name: .SmilesBaseMainRequestManager, targets: [.SmilesBaseMainRequestManager, .SmilesBaseMainRequestManager])
    static let SmilesSharedServices = library(name: .SmilesSharedServices, targets: [.SmilesSharedServices, .SmilesSharedServices])
    static let NetworkingLayer = library(name: .NetworkingLayer, targets: [.NetworkingLayer, .NetworkingLayer])
    static let SmilesEmailVerification = library(name: .SmilesEmailVerification, targets: [.SmilesEmailVerification, .SmilesEmailVerification])
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
                                        dependencies: [.SmilesFontsManager, 
                                            .SmilesLanguageManager,
                                            .CryptoSwift,
                                            .SkeletonView,
                                            .SDWebImage],
                                        path: "SmilesUtilities/Sources/SmilesUtilities/")
    
    static let SmilesLoader = target(name: .SmilesLoader,
                                        dependencies: [.SmilesFontsManager, 
                                            .SmilesUtilities,
                                            .NVActivityIndicatorView],
                                        path: "SmilesLoader/Sources/SmilesLoader/")
    
    static let SmilesBaseMainRequestManager = target(name: .SmilesBaseMainRequestManager,
                                        dependencies: [.SmilesUtilities],
                                        path: "SmilesBaseMainRequestManager/Sources/SmilesBaseMainRequestManager/")
    
    static let SmilesSharedServices = target(name: .SmilesSharedServices,
                                             dependencies: [.SmilesBaseMainRequestManager,
                                                            .NetworkingLayer],
                                        path: "SmilesSharedServices/Sources/SmilesSharedServices/")
    
    static let NetworkingLayer = target(name: .NetworkingLayer,
                                        dependencies: [.SmilesBaseMainRequestManager,
                                                       .SmilesLanguageManager,
                                                       .SmilesStorage,
                                                       .SmilesUtilities,
                                                       .Alamofire,
                                                       .CryptoSwift],
                                        path: "NetworkingLayer/Sources/NetworkingLayer/")
    
    static let SmilesEmailVerification = target(name: .SmilesEmailVerification,
                                        dependencies: [.SmilesBaseMainRequestManager,
                                                       .SmilesLanguageManager,
                                                       .SmilesFontsManager,
                                                       .SkeletonView,
                                                       .SmilesUtilities,
                                                       .NetworkingLayer,
                                                       .SDWebImage,
                                                       .CryptoSwift],
                                        path: "SmilesEmailVerification/Sources/SmilesEmailVerification/")
}


extension Target.Dependency {
    static let SmilesFontsManager = byName(name: .SmilesFontsManager)
    static let SmilesUtilities = byName(name: .SmilesUtilities)
    static let SmilesStorage = byName(name: .SmilesStorage)
    static let SmilesLanguageManager = byName(name: .SmilesLanguageManager)
    static let SmilesBaseMainRequestManager = byName(name: .SmilesBaseMainRequestManager)
    static let NetworkingLayer = byName(name: .NetworkingLayer)
    static let SmilesEmailVerification = byName(name: .SmilesEmailVerification)
    static let CryptoSwift = byName(name: "CryptoSwift")
    static let SkeletonView = byName(name: "SkeletonView")
    static let SDWebImage = byName(name: "SDWebImage")
    static let NVActivityIndicatorView = byName(name: "NVActivityIndicatorView")
    static let Alamofire = byName(name: "Alamofire")
}
