//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/06/2023.
//

import Foundation
import UIKit
import SmilesUtilities
import SmilesLanguageManager

@objc public class EasyTipViewPreference : NSObject {
    
    public weak var tipView: EasyTipView?
    
    enum TipOrder {
        case voucher
        case bogo
        case bills
        case profile
    }
    
    
    public static func locationTipPreferences() -> EasyTipView.Preferences{
        let preferences = EasyTipView.globalPreferences
        preferences.drawing.backgroundColor = UIColor.clear
        preferences.animating.showInitialAlpha = 1
        preferences.animating.showDuration = 1
        preferences.animating.dismissDuration = 1
        //preferences.positioning.maxWidth = 256
        preferences.drawing.shadowRadius = 2
        preferences.drawing.shadowOpacity = 0.75
        preferences.drawing.arrowPosition = .bottom
        preferences.drawing.cornerRadius = 12
        preferences.drawing.arrowWidth = 10
        preferences.drawing.arrowHeight = 10
        //preferences.positioning.bubbleInsets = 8
        //preferences.positioning.bubbleInsets = 8
        
        return preferences
        
    }
    
    
    
    static private func homeSceenToolTipPreference(arrowPosition arrow : EasyTipView.ArrowPosition, bubbleHInset : CGFloat) -> EasyTipView.Preferences {
        
        let preferences = EasyTipView.Preferences()
        preferences.drawing.backgroundColor = .homeToolTipPrimaryColor
        preferences.drawing.borderColor = .homeToolTipBorderPrimaryColor
        preferences.drawing.borderWidth = 1.0
        preferences.drawing.cornerRadius = 5.0
        preferences.drawing.font = UIFont(name: "Lato-Black", size: 13)!
        preferences.drawing.textAlignment = .left
        if SmilesLanguageManager.shared.currentLanguage == .ar {
            preferences.drawing.textAlignment = .right
        }
        preferences.drawing.shadowColor = UIColor.black
        preferences.drawing.shadowRadius = 2
        preferences.drawing.shadowOpacity = 0.75
        preferences.drawing.arrowPosition = arrow
        preferences.animating.showDuration = 0
        preferences.animating.dismissDuration = 1
        //preferences.positioning.bubbleInsets = bubbleHInset
        //preferences.positioning.bubbleInsets = 0
        
        
        return preferences
    }
    
    static private func buy1Get1ToolTipPreference(arrowPosition arrow : EasyTipView.ArrowPosition, bubbleHInset : CGFloat) -> EasyTipView.Preferences {
        
        let preferences = EasyTipView.Preferences()
        preferences.drawing.backgroundColor = .appOrangeColorNew
        preferences.drawing.cornerRadius = 12.0
        preferences.drawing.font = .latoSemiBoldFont(size: 12)
        preferences.drawing.textAlignment = .left
        if SmilesLanguageManager.shared.currentLanguage == .ar {
            preferences.drawing.textAlignment = .right
        }
        preferences.drawing.shadowColor = UIColor.black
        preferences.drawing.arrowPosition = arrow
        preferences.animating.showDuration = 0
        preferences.animating.dismissDuration = 1
        
        return preferences
    }
    
    
    @objc public  static func showTip(forView view : UIView, withInSuperView superView : UIView?, withText text : String, arrowPosition arrow : EasyTipView.ArrowPosition, bubbleHInset : CGFloat, completion: @escaping (() -> Void)){
        
        if !text.isEmpty{
            let tip = EasyTipView(text: text, preferences: homeSceenToolTipPreference(arrowPosition: arrow, bubbleHInset: bubbleHInset), delegate: nil)
            tip.show(forView: view)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                tip.dismiss {
                    completion()
                }
            }
        }
    }
    
    
    public static func showTip(forItem barItem : UIBarItem, withText text : String, arrowPosition arrow : EasyTipView.ArrowPosition, bubbleHInset : CGFloat, completion: @escaping (() -> Void)){
        
        if !text.isEmpty{
            let tip = EasyTipView(text: text, preferences: homeSceenToolTipPreference(arrowPosition: arrow, bubbleHInset: bubbleHInset), delegate: nil)
            tip.show(forItem: barItem)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                tip.dismiss {
                    completion()
                }
            }
        } else {
            completion()
        }
    }
    
    public static func showTipForBuy1Get1(forView view : UIView, withInSuperView superView : UIView?, withText text : String, arrowPosition arrow : EasyTipView.ArrowPosition, bubbleHInset : CGFloat, completion: @escaping (() -> Void)){
        
        if !text.isEmpty{
            let tip = EasyTipView(text: text, preferences: buy1Get1ToolTipPreference(arrowPosition: arrow, bubbleHInset: bubbleHInset), delegate: nil)
            tip.show(forView: view)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                tip.dismiss {
                    completion()
                }
            }
        }
    }
    
    
}

public class ToolTipBuilder{
    
    public enum TipSection {
        case home
    }
    
    public func build(_ style: TipSection) -> EasyTipViewPreference {
        switch style {
        case .home:
            return EasyTipViewPreference.init()
            
        }
    }
    
    
}


public class LocationToolTipHandler {
    public static func saveToolTipStateOnHome(bool: Bool) {
        UserDefaults.standard.set(bool, forKey: UserDefaultKeys.showLocationToolTipOnHome)
    }
    
    public static func showToolTipOnHome() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.showLocationToolTipOnHome)
    }
    
    public static func saveToolTipStateOnRestaurantHome(bool: Bool) {
        UserDefaults.standard.set(bool, forKey: UserDefaultKeys.showLocationToolTipOnRestaurant)
    }
    
    public static func showToolTipOnRestaurantHome() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.showLocationToolTipOnRestaurant)
    }
}
