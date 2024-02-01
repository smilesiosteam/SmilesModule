
//
//  SmilesLanguageManager.swift
//  House
//
//  Created by Hanan Ahmed on 11/2/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import Foundation
import SmilesStorage

public class SmilesLanguageManager {
    
    public typealias Animation = ((UIView) -> Void)
    public typealias ViewControllerFactory = ((String?) -> UIViewController)
    public typealias WindowAndTitle = (UIWindow?, String?)
    
    // MARK: - Private properties
    
    private var storage = SmilesStorageHandler(storageType: .userDefaults)
    private var englishResources = [String: Any]()
    private var arabicResources = [String: Any]()
    
    // MARK: - Properties
    
    ///
    /// The singleton SmilesLanguageManager instance.
    ///
    public static let shared = SmilesLanguageManager()
    
    private init() {
        
        if let englishDictionary = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "English_Resources", ofType: "plist") ?? "") as? [String: Any] {
            self.englishResources = englishDictionary
        }
        
        if let arabicDictionary = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Arabic_Resources", ofType: "plist") ?? "") as? [String: Any] {
            self.arabicResources = arabicDictionary
        }
    }
    
    ///
    /// Current app language.
    /// *Note, This property just to get the current lanuage,
    /// To set the language use:
    /// `setLanguage(language:, for:, viewControllerFactory:, animation:)`*
    ///
    public private(set) var currentLanguage: Languages {
        get {
            guard let currentLang: String = storage.getValue(forKey: .selectedLanguage) else {
                return .en
            }
            return Languages(rawValue: currentLang)!
        }
        set {
            storage.setValue(newValue.rawValue, forKey: .selectedLanguage)
        }
    }
    
    public func getLanguageResource() -> [String: Any]? {
        if self.currentLanguage == .ar {
            return self.arabicResources
        }
        return self.englishResources
    }
    
    public func getLocalizedString(for key: String) -> String {
        guard let value = self.getLanguageResource()?[key] as? String else { return ""}
        
        return value
    }
    
    
    ///
    /// The default language that the app will run with first time.
    /// You need to set the `defaultLanguage` in the `AppDelegate`, specifically in
    /// the first line inside the `application(_:willFinishLaunchingWithOptions:)` method.
    ///
    public var defaultLanguage: Languages {
        get {
            guard let defaultLanguage: String = storage.getValue(forKey: .defaultLanguage) else {
                return .en
            }
            return Languages(rawValue: defaultLanguage)!
        }
        set {
            // swizzle the awakeFromNib from nib and localize the text in the new awakeFromNib
            UIView.localize()
            
            let defaultLanguage: String? = storage.getValue(forKey: .defaultLanguage)
            guard defaultLanguage == nil else {
                // If the default language has been set before,
                // that means that the user opened the app before and maybe
                // he changed the language so here the `currentLanguage` is being set.
                setLanguage(language: currentLanguage)
                return
            }
            
            var language = newValue
            if language == .deviceLanguage {
                language = deviceLanguage ?? .en
            }
            
            storage.setValue(language.rawValue, forKey: .defaultLanguage)
            storage.setValue(language.rawValue, forKey: .selectedLanguage)
            setLanguage(language: language)
        }
    }
    
    ///
    /// The device language is deffrent than the app language,
    /// to get the app language use `currentLanguage`.
    ///
    public var deviceLanguage: Languages? {
        guard let deviceLanguage = Bundle.main.preferredLocalizations.first else {
            return nil
        }
        return Languages(rawValue: deviceLanguage)
    }
    
    /// The diriction of the language.
    public var isRightToLeft: Bool {
        return isLanguageRightToLeft(language: currentLanguage)
    }
    
    /// The app locale to use it in dates and currency.
    public var appLocale: Locale {
        return Locale(identifier: currentLanguage.rawValue)
    }
    
    // MARK: - Public Methods
    
    ///
    /// Set the current language of the app
    ///
    /// - parameter language: The language that you need the app to run with.
    /// - parameter windows: The windows you want to change the `rootViewController` for. if you didn't
    ///                      set it, it will change the `rootViewController` for all the windows in the
    ///                      scenes.
    /// - parameter viewControllerFactory: A closure to make the `ViewController` for a specific `scene`,
    ///                                    you can know for which `scene` you need to make the controller you can check
    ///                                    the `title` sent to this clouser, this title is the `title` of the `scene`,
    ///                                    so if there is 5 scenes this closure will get called 5 times
    ///                                    for each scene window.
    /// - parameter animation: A closure with the current view to animate to the new view controller,
    ///                        so you need to animate the view, move it out of the screen, change the alpha,
    ///                        or scale it down to zero.
    ///
    public func setLanguage(language: Languages,
                            for windows: [WindowAndTitle]? = nil,
                            viewControllerFactory: ViewControllerFactory? = nil,
                            animation: Animation? = nil) {
        
        changeCurrentLanguageTo(language)
        
        guard let viewControllerFactory = viewControllerFactory else {
            return
        }
        
        let windowsToChange = getWindowsToChangeFrom(windows)
        
        windowsToChange?.forEach({ windowAndTitle in
            let (window, title) = windowAndTitle
            let viewController = viewControllerFactory(title)
            changeViewController(for: window,
                                 rootViewController: viewController,
                                 animation: animation)
        })
        
    }
    
    // MARK: - Private Methods
    
    private func changeCurrentLanguageTo(_ language: Languages) {
        // change the dircation of the views
        let semanticContentAttribute: UISemanticContentAttribute = isLanguageRightToLeft(language: language) ?
            .forceRightToLeft :
            .forceLeftToRight
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        
        // set current language
        currentLanguage = language
    }
    
    private func getWindowsToChangeFrom(_ windows: [WindowAndTitle]?) -> [WindowAndTitle]? {
        var windowsToChange: [WindowAndTitle]?
        if let windows = windows {
            windowsToChange = windows
        } else {
            windowsToChange = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .map({ ($0.windows.first, $0.title) })
        }
        
        return windowsToChange
    }
    
    private func changeViewController(for window: UIWindow?,
                                      rootViewController: UIViewController,
                                      animation: Animation? = nil) {
        guard let snapshot = window?.snapshotView(afterScreenUpdates: true) else {
            return
        }
        rootViewController.view.addSubview(snapshot)
        
        window?.rootViewController = rootViewController
        
        UIView.animate(withDuration: 0.5, animations: {
            animation?(snapshot)
        }, completion: { _ in
            snapshot.removeFromSuperview()
        })
    }
    
    private func isLanguageRightToLeft(language: Languages) -> Bool {
        if #available(iOS 16, *) {
            return Locale.Language(identifier: language.rawValue).characterDirection == .rightToLeft
        } else {
            // Fallback on earlier versions
           return Locale.characterDirection(forLanguage: language.rawValue) == .rightToLeft
        }
    }
    
}
