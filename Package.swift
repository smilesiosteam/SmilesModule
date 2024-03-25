// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
 
let package = Package(
    name: "SmilesModule",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .SmilesFontsManager,
        .SmilesUtilities,
        .SmilesLoader,
        .SmilesStorage,
        .SmilesLanguageManager,
        .SmilesBaseMainRequestManager,
        .NetworkingLayer,
        .SmilesEmailVerification,
        .LottieAnimationManager,
        .SmilesStoriesManager,
        .SmilesSharedServices,
        .AnalyticsSmiles,
        .SmilesEasyTipView,
        .SmilesLocationHandler,
        .SmilesOffers,
        .SmilesPageController,
        .SmilesBanners,
        .SmilesTutorials,
        .SmilesScratchHandler,
        .AppHeader,
        .SmilesPersonalizationEvent,
        .SmilesYoutubePopUpView,
        .SmilesSubscriptionPromotion,
        .DeviceAppCheck,
        .SmilesOnboarding,
        .SmilesOcassionThemes,
        .SmilesReusableComponents,
        .SmilesManCity,
        .SmilesFilterAndSort,
        .SmilesExplorer,
        .SmilesOrderTracking,
        //.SmilesTests,
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.8.0")),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0"),
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", from: "5.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.4")),
        .package(url: "https://github.com/airbnb/lottie-ios.git", exact: "3.5.0"),
        .package(url: "https://github.com/youtube/youtube-ios-player-helper.git", from: "1.0.4"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.6.0"),
        .package(url: "https://github.com/wxxsw/SwiftTheme.git", branch: "master"),
        .package(url: "https://github.com/YAtechnologies/GoogleMaps-SP.git", .upToNextMinor(from: "7.2.0")),
        .package(url: "https://github.com/sabarics/PlaceholderUITextView.git", branch: "master"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", .upToNextMajor(from: "23.0.0")),
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
        .LottieAnimationManager,
        .SmilesStoriesManager,
        .SmilesSharedServices,
        .AnalyticsSmiles,
        .SmilesEasyTipView,
        .SmilesLocationHandler,
        .SmilesOffers,
        .SmilesPageController,
        .SmilesBanners,
        .SmilesTutorials,
        .SmilesScratchHandler,
        .AppHeader,
        .SmilesPersonalizationEvent,
        .SmilesYoutubePopUpView,
        .SmilesSubscriptionPromotion,
        .DeviceAppCheck,
        .SmilesOnboarding,
        .SmilesOcassionThemes,
        .SmilesReusableComponents,
        .SmilesManCity,
        .SmilesFilterAndSort,
        .SmilesExplorer,
        .SmilesOrderTracking,
        //.SmilesTests,
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
    static let LottieAnimationManager = "LottieAnimationManager"
    static let SmilesStoriesManager = "SmilesStoriesManager"
    static let AnalyticsSmiles = "AnalyticsSmiles"
    static let SmilesEasyTipView = "SmilesEasyTipView"
    static let SmilesLocationHandler = "SmilesLocationHandler"
    static let SmilesOffers = "SmilesOffers"
    static let SmilesPageController = "SmilesPageController"
    static let SmilesBanners = "SmilesBanners"
    static let SmilesTutorials = "SmilesTutorials"
    static let SmilesScratchHandler = "SmilesScratchHandler"
    static let AppHeader = "AppHeader"
    static let SmilesPersonalizationEvent = "SmilesPersonalizationEvent"
    static let SmilesYoutubePopUpView = "SmilesYoutubePopUpView"
    static let SmilesSubscriptionPromotion = "SmilesSubscriptionPromotion"
    static let DeviceAppCheck = "DeviceAppCheck"
    static let SmilesOnboarding = "SmilesOnboarding"
    static let SmilesOcassionThemes = "SmilesOcassionThemes"
    static let SmilesReusableComponents = "SmilesReusableComponents"
    static let SmilesManCity = "SmilesManCity"
    static let SmilesFilterAndSort = "SmilesFilterAndSort"
    static let SmilesExplorer = "SmilesExplorer"
    static let SmilesOrderTracking = "SmilesOrderTracking"
    static let SmilesTests = "SmilesTests"

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
    static let SmilesLanguageManager = library(name: .SmilesLanguageManager, targets: [.SmilesLanguageManager])
    static let SmilesBaseMainRequestManager = library(name: .SmilesBaseMainRequestManager, targets: [.SmilesBaseMainRequestManager])
    static let SmilesSharedServices = library(name: .SmilesSharedServices, targets: [.SmilesSharedServices])
    static let NetworkingLayer = library(name: .NetworkingLayer, targets: [.NetworkingLayer])
    static let SmilesEmailVerification = library(name: .SmilesEmailVerification, targets: [.SmilesEmailVerification])
    static let LottieAnimationManager = library(name: .LottieAnimationManager, targets: [.LottieAnimationManager])
    static let SmilesStoriesManager = library(name: .SmilesStoriesManager, targets: [.SmilesStoriesManager])
    static let AnalyticsSmiles = library(name: .AnalyticsSmiles, targets: [.AnalyticsSmiles])
    static let SmilesEasyTipView = library(name: .SmilesEasyTipView, targets: [.SmilesEasyTipView])
    static let SmilesLocationHandler = library(name: .SmilesLocationHandler, targets: [.SmilesLocationHandler])
    static let SmilesOffers = library(name: .SmilesOffers, targets: [.SmilesOffers])
    static let SmilesPageController = library(name: .SmilesPageController, targets: [.SmilesPageController])
    static let SmilesBanners = library(name: .SmilesBanners, targets: [.SmilesBanners])
    static let SmilesTutorials = library(name: .SmilesTutorials, targets: [.SmilesTutorials])
    static let SmilesScratchHandler = library(name: .SmilesScratchHandler, targets: [.SmilesScratchHandler])
    static let AppHeader = library(name: .AppHeader, targets: [.AppHeader])
    static let SmilesPersonalizationEvent = library(name: .SmilesPersonalizationEvent, targets: [.SmilesPersonalizationEvent])
    static let SmilesYoutubePopUpView = library(name: .SmilesYoutubePopUpView, targets: [.SmilesYoutubePopUpView])
    static let SmilesSubscriptionPromotion = library(name: .SmilesSubscriptionPromotion, targets: [.SmilesSubscriptionPromotion])
    static let DeviceAppCheck = library(name: .DeviceAppCheck, targets: [.DeviceAppCheck])
    static let SmilesOnboarding = library(name: .SmilesOnboarding, targets: [.SmilesOnboarding])
    static let SmilesOcassionThemes = library(name: .SmilesOcassionThemes, targets: [.SmilesOcassionThemes])
    static let SmilesReusableComponents = library(name: .SmilesReusableComponents, targets: [.SmilesReusableComponents])
    static let SmilesManCity = library(name: .SmilesManCity, targets: [.SmilesManCity])
    static let SmilesFilterAndSort = library(name: .SmilesFilterAndSort, targets: [.SmilesFilterAndSort])
    static let SmilesExplorer = library(name: .SmilesExplorer, targets: [.SmilesExplorer])
    static let SmilesOrderTracking = library(name: .SmilesOrderTracking, targets: [.SmilesOrderTracking])
    static let SmilesTests = library(name: .SmilesTests, targets: [.SmilesTests])
}

extension Target {
   
    static let SmilesMonoRepo = target(name: .SmilesMonoRepo)
    
    static let SmilesStorage = target(name: .SmilesStorage, dependencies: [],
                                           path: "SmilesStorage/Sources")
    
    static let SmilesLanguageManager = target(name: .SmilesLanguageManager, 
                                              dependencies: [.SmilesStorage],
                                              path: "SmilesLanguageManager/Sources")
    
    static let SmilesFontsManager = target(name: .SmilesFontsManager, dependencies: [],
                                           path: "SmilesFontsManager/Sources")
    
    static let SmilesUtilities = target(name: .SmilesUtilities,
                                        dependencies: [.SmilesFontsManager, 
                                            .SmilesLanguageManager,
                                            .CryptoSwift,
                                            .SkeletonView,
                                            .SDWebImage],
                                        path: "SmilesUtilities/Sources")
    
    static let SmilesLoader = target(name: .SmilesLoader,
                                        dependencies: [.SmilesFontsManager, 
                                            .SmilesUtilities,
                                            .NVActivityIndicatorView],
                                        path: "SmilesLoader/Sources")
    
    static let SmilesBaseMainRequestManager = target(name: .SmilesBaseMainRequestManager,
                                        dependencies: [.SmilesUtilities],
                                        path: "SmilesBaseMainRequestManager/Sources")
    
    static let SmilesSharedServices = target(name: .SmilesSharedServices,
                                             dependencies: [.SmilesBaseMainRequestManager,
                                                            .NetworkingLayer],
                                        path: "SmilesSharedServices/Sources")
    
    static let SmilesEasyTipView = target(name: .SmilesEasyTipView,
                                             dependencies: [.SmilesUtilities,
                                                            .SmilesLanguageManager],
                                        path: "SmilesEasyTipView/Sources")
    
    static let NetworkingLayer = target(name: .NetworkingLayer,
                                        dependencies: [.SmilesBaseMainRequestManager,
                                                       .SmilesLanguageManager,
                                                       .SmilesStorage,
                                                       .SmilesUtilities,
                                                       .Alamofire,
                                                       .CryptoSwift],
                                        path: "NetworkingLayer/Sources")
    
    static let SmilesEmailVerification = target(name: .SmilesEmailVerification,
                                        dependencies: [.SmilesBaseMainRequestManager,
                                                       .SmilesLanguageManager,
                                                       .SmilesFontsManager,
                                                       .SkeletonView,
                                                       .SmilesUtilities,
                                                       .NetworkingLayer,
                                                       .SDWebImage,
                                                       .CryptoSwift],
                                        path: "SmilesEmailVerification/Sources")
    
    static let SmilesTutorials = target(name: .SmilesTutorials,
                                        dependencies: [.SmilesBaseMainRequestManager,
                                                       .SmilesLanguageManager,
                                                       .SmilesFontsManager,
                                                       .SkeletonView,
                                                       .SmilesUtilities,
                                                       .SmilesPageController,
                                                       .SDWebImage,
                                                       .CryptoSwift,
                                                       .LottieAnimationManager],
                                        path: "SmilesTutorials/Sources")
    
    static let SmilesStoriesManager = target(name: .SmilesStoriesManager,
                                        dependencies: [.SmilesBaseMainRequestManager,
                                                       .SmilesLanguageManager,
                                                       .SmilesFontsManager,
                                                       .LottieAnimationManager,
                                                       .SmilesSharedServices,
                                                       .SmilesUtilities,
                                                       .NetworkingLayer,
                                                       .SmilesLoader],
                                        path: "SmilesStoriesManager/Sources")
    
    static let SmilesOnboarding = target(name: .SmilesOnboarding,
                                        dependencies: [.SmilesBaseMainRequestManager,
                                                       .SmilesLanguageManager,
                                                       .SmilesFontsManager,
                                                       .LottieAnimationManager,
                                                       .NetworkingLayer,
                                                       .DeviceAppCheck,
                                                       .SmilesLocationHandler,
                                                       .PhoneNumberKit,
                                                       .SmilesLoader],
                                        path: "SmilesOnboarding/Sources")
    
    static let SmilesLocationHandler = target(name: .SmilesLocationHandler,
                                        dependencies: [.SmilesEasyTipView,
                                                       .AnalyticsSmiles,
                                                       .SmilesUtilities,
                                                       .NetworkingLayer,
                                                       .SmilesBaseMainRequestManager,
                                                       .SmilesLoader,
                                                       .GoogleMaps,
                                                       .GooglePlaces,
                                                       .SmilesLanguageManager],
                                        path: "SmilesLocationHandler/Sources")
    
    static let SmilesScratchHandler = target(name: .SmilesScratchHandler,
                                        dependencies: [.SmilesFontsManager,
                                                       .SmilesLanguageManager,
                                                       .SmilesUtilities,
                                                       .NetworkingLayer,
                                                       .SmilesBaseMainRequestManager,
                                                       .SmilesLoader],
                                        path: "SmilesScratchHandler/Sources")
    
    static let SmilesSubscriptionPromotion = target(name: .SmilesSubscriptionPromotion,
                                                    dependencies: [.SmilesYoutubePopUpView,
                                                                   .SmilesSharedServices,
                                                                   .SmilesOffers,
                                                                   .SmilesBanners,
                                                                   .SmilesFontsManager,
                                                                   .SmilesLanguageManager,
                                                                   .SmilesUtilities,
                                                                   .SmilesStoriesManager,
                                                                   .SmilesBaseMainRequestManager,
                                                                   .SmilesLoader],
                                        path: "SmilesSubscriptionPromotion/Sources")
    
    static let SmilesManCity = target(name: .SmilesManCity,
                                                    dependencies: [.YoutubePlayer,
                                                                   .SmilesFontsManager,
                                                                   .SmilesUtilities,
                                                                   .SmilesSharedServices,
                                                                   .SmilesLocationHandler,
                                                                   .SmilesLanguageManager,
                                                                   .SmilesLoader,
                                                                   .SmilesOffers,
                                                                   .SmilesBaseMainRequestManager,
                                                                   .PhoneNumberKit,
                                                                   .SmilesReusableComponents,
                                                                   .SmilesStoriesManager,
                                                                   .SmilesBanners,
                                                                   .AppHeader],
                                        path: "SmilesManCity/Sources")
    
    static let SmilesOcassionThemes = target(name: .SmilesOcassionThemes,
                                                    dependencies: [.SmilesFontsManager,
                                                                   .SmilesUtilities,
                                                                   .SmilesSharedServices,
                                                                   .SmilesLanguageManager,
                                                                   .SmilesLoader,
                                                                   .SmilesBaseMainRequestManager,
                                                                   .SmilesOffers,
                                                                   .SmilesBanners,
                                                                   .SmilesStoriesManager],
                                        path: "SmilesOcassionThemes/Sources")
    
    static let SmilesOffers = target(name: .SmilesOffers,
                                        dependencies: [.LottieAnimationManager,
                                                       .SmilesUtilities,
                                                       .NetworkingLayer,
                                                       .SmilesBaseMainRequestManager],
                                        path: "SmilesOffers/Sources")
    
    static let SmilesBanners = target(name: .SmilesBanners,
                                        dependencies: [.LottieAnimationManager,
                                                       .SmilesPageController,
                                                       .SmilesUtilities,
                                                       .NetworkingLayer,
                                                       .SmilesBaseMainRequestManager],
                                        path: "SmilesBanners/Sources")
    
    static let AppHeader = target(name: .AppHeader,
                                        dependencies: [.LottieAnimationManager,
                                                       .SmilesLocationHandler],
                                        path: "SmilesAppHeader/Sources")
    
    static let SmilesPersonalizationEvent = target(name: .SmilesPersonalizationEvent,
                                        dependencies: [.SmilesUtilities,
                                                       .NetworkingLayer],
                                        path: "SmilesPersonalizationEvent/Sources")
    
    static let SmilesExplorer = target(name: .SmilesExplorer,
                                        dependencies: [.SmilesFontsManager,
                                                       .SmilesUtilities,
                                                       .SmilesSharedServices,
                                                       .SmilesLanguageManager,
                                                       .SmilesLoader,
                                                       .SmilesBaseMainRequestManager,
                                                       .SmilesOffers,
                                                       .SmilesBanners,
                                                       .AppHeader,
                                                       .SmilesFilterAndSort,
                                                       .SmilesStoriesManager],
                                        path: "SmilesExplorer/Sources")
    
    static let SmilesReusableComponents = target(name: .SmilesReusableComponents,
                                        dependencies: [.SmilesUtilities,
                                                       .SmilesFontsManager,
                                                       .SmilesLanguageManager,
                                                       .SmilesSharedServices,
                                                       .SwiftTheme],
                                        path: "SmilesReusableComponents/Sources")
    
    static let SmilesFilterAndSort = target(name: .SmilesFilterAndSort,
                                        dependencies: [.SmilesUtilities,
                                                       .SmilesFontsManager,
                                                       .NetworkingLayer,
                                                       .SmilesOffers],
                                        path: "SmilesFilterAndSort/Sources")
    
    static let LottieAnimationManager = target(name: .LottieAnimationManager,
                                               dependencies: [.Lottie],
                                        path: "LottieAnimationManager/Sources")
    
    static let SmilesYoutubePopUpView = target(name: .SmilesYoutubePopUpView,
                                               dependencies: [.YoutubePlayer, .SmilesUtilities],
                                        path: "SmilesYoutubePopUpView/Sources")
    
    static let SmilesOrderTracking = target(name: .SmilesOrderTracking,
                                               dependencies: [.SmilesUtilities,
                                                              .SmilesFontsManager,
                                                              .GoogleMaps,
                                                              .SmilesBaseMainRequestManager,
                                                              .NetworkingLayer,
                                                              .LottieAnimationManager,
                                                              .SmilesLoader,
                                                              .SDWebImage,
                                                              .PlaceholderUITextView,
                                                              .SmilesScratchHandler,
                                                              .SmilesSharedServices,
                                                              //.SmilesTests,
                                                              .Cosmos],
                                        path: "SmilesOrderTracking/Sources")
    
    static let AnalyticsSmiles = target(name: .AnalyticsSmiles,
                                        path: "SmilesAnalytics/Sources")
    
    static let SmilesPageController = target(name: .SmilesPageController,
                                        path: "SmilesPageController/Sources")
    
    static let DeviceAppCheck = target(name: .DeviceAppCheck,
                                        path: "DeviceAppCheck/Sources")
    
    static let SmilesTests = target(name: .SmilesTests,
                                        path: "SmilesTests/Sources")
}


extension Target.Dependency {
    static let SmilesFontsManager = byName(name: .SmilesFontsManager)
    static let SmilesUtilities = byName(name: .SmilesUtilities)
    static let SmilesStorage = byName(name: .SmilesStorage)
    static let SmilesLanguageManager = byName(name: .SmilesLanguageManager)
    static let SmilesBaseMainRequestManager = byName(name: .SmilesBaseMainRequestManager)
    static let NetworkingLayer = byName(name: .NetworkingLayer)
    static let SmilesEmailVerification = byName(name: .SmilesEmailVerification)
    static let LottieAnimationManager = byName(name: .LottieAnimationManager)
    static let SmilesStoriesManager = byName(name: .SmilesStoriesManager)
    static let SmilesLoader = byName(name: .SmilesLoader)
    static let SmilesSharedServices = byName(name: .SmilesSharedServices)
    static let AnalyticsSmiles = byName(name: .AnalyticsSmiles)
    static let SmilesEasyTipView = byName(name: .SmilesEasyTipView)
    static let SmilesLocationHandler = byName(name: .SmilesLocationHandler)
    static let SmilesOffers = byName(name: .SmilesOffers)
    static let SmilesPageController = byName(name: .SmilesPageController)
    static let SmilesBanners = byName(name: .SmilesBanners)
    static let SmilesTutorials = byName(name: .SmilesTutorials)
    static let SmilesScratchHandler = byName(name: .SmilesScratchHandler)
    static let AppHeader = byName(name: .AppHeader)
    static let SmilesOrderTracking = byName(name: .SmilesOrderTracking)
    static let SmilesTests = byName(name: .SmilesTests)
    
    static let SmilesPersonalizationEvent = byName(name: .SmilesPersonalizationEvent)
    static let SmilesYoutubePopUpView = byName(name: .SmilesYoutubePopUpView)
    static let SmilesSubscriptionPromotion = byName(name: .SmilesSubscriptionPromotion)
    static let DeviceAppCheck = byName(name: .DeviceAppCheck)
    static let SmilesOnboarding = byName(name: .SmilesOnboarding)
    static let SmilesOcassionThemes = byName(name: .SmilesOcassionThemes)
    static let SmilesReusableComponents = byName(name: .SmilesReusableComponents)
    static let SmilesManCity = byName(name: .SmilesManCity)
    static let SmilesFilterAndSort = byName(name: .SmilesFilterAndSort)
    static let SmilesExplorer = byName(name: .SmilesExplorer)
    
    static let GoogleMaps =   product(name: "GoogleMaps", package: "GoogleMaps-SP")
    static let GooglePlaces =   product(name: "GooglePlaces", package: "GoogleMaps-SP")
    static let Cosmos =   product(name: "Cosmos", package: "Cosmos")
    static let PlaceholderUITextView = product(name: "PlaceholderUITextView", package: "PlaceholderUITextView")
    static let Lottie = product(name: "Lottie", package: "lottie-ios")
    static let CryptoSwift = byName(name: "CryptoSwift")
    static let SkeletonView = byName(name: "SkeletonView")
    static let SDWebImage = byName(name: "SDWebImage")
    static let NVActivityIndicatorView = byName(name: "NVActivityIndicatorView")
    static let Alamofire = byName(name: "Alamofire")
    static let YoutubePlayer = product(name: "YouTubeiOSPlayerHelper", package: "youtube-ios-player-helper")
    static let PhoneNumberKit = product(name: "PhoneNumberKit", package: "PhoneNumberKit")
    static let SwiftTheme = product(name: "SwiftTheme", package: "SwiftTheme")
}
