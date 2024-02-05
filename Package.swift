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
        .SmilesBaseMainRequest,
        .NetworkingLayer
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
        .SmilesBaseMainRequest,
        .NetworkingLayer,
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
    static let SmilesBaseMainRequest = "SmilesBaseMainRequest"
    static let SmilesSharedServices = "SmilesSharedServices"

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
    static let SmilesBaseMainRequest = library(name: .SmilesBaseMainRequest, targets: [.SmilesBaseMainRequest, .SmilesBaseMainRequest])
    static let SmilesSharedServices = library(name: .SmilesSharedServices, targets: [.SmilesSharedServices, .SmilesSharedServices])
    static let NetworkingLayer = library(name: .NetworkingLayer, targets: [.NetworkingLayer, .NetworkingLayer])
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
    
    static let SmilesBaseMainRequest = target(name: .SmilesBaseMainRequest,
                                        dependencies: [.SmilesUtilities],
                                        path: "SmilesBaseMainRequest/Sources/SmilesBaseMainRequest/")
    
    static let SmilesSharedServices = target(name: .SmilesSharedServices,
                                             dependencies: [.SmilesBaseMainRequest,
                                                            .NetworkingLayer],
                                        path: "SmilesSharedServices/Sources/SmilesSharedServices/")
    
    static let NetworkingLayer = target(name: .NetworkingLayer,
                                        dependencies: [.SmilesBaseMainRequest,
                                                       .SmilesLanguageManager,
                                                       .SmilesStorage,
                                                       .SmilesUtilities,
                                                       .Alamofire,
                                                       .CryptoSwift],
                                        path: "NetworkingLayer/Sources/NetworkingLayer/")
}


extension Target.Dependency {
    static let SmilesFontsManager = byName(name: .SmilesFontsManager)
    static let SmilesUtilities = byName(name: .SmilesUtilities)
    static let SmilesStorage = byName(name: .SmilesStorage)
    static let SmilesLanguageManager = byName(name: .SmilesLanguageManager)
    static let SmilesBaseMainRequest = byName(name: .SmilesBaseMainRequest)
    static let NetworkingLayer = byName(name: .NetworkingLayer)
    static let CryptoSwift = byName(name: "CryptoSwift")
    static let SkeletonView = byName(name: "SkeletonView")
    static let SDWebImage = byName(name: "SDWebImage")
    static let NVActivityIndicatorView = byName(name: "NVActivityIndicatorView")
    static let Alamofire = byName(name: "Alamofire")
}
