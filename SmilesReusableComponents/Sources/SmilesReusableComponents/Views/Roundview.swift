//
//  File.swift
//  
//
//  Created by Habib Rehman on 10/10/2023.
//

import Foundation
import SwiftTheme
import UIKit

@objc public class RoundUIView: UIView {
    
    @IBInspectable public var bgThemIdentifier: String = "NavigationBarColor" {
        didSet {
            theme_backgroundColor = ThemeColorPicker(stringLiteral: bgThemIdentifier)
        }
    }
    
    
    @IBInspectable public var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    public var shadowOffset : CGSize{
        
        get{
            return layer.shadowOffset
        }set{
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    public var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    public var shadowOpacity : Float {
        
        get{
            return layer.shadowOpacity
        }
        set {
            
            layer.shadowOpacity = newValue
            
        }
    }
}

extension CALayer {
    public var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}

extension UIView{
    
    public class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}


@IBDesignable public class ShadowView: UIView {

    @IBInspectable public var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable public var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }

     }

    @IBInspectable public var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
        }
    }

    @IBInspectable public var shadowSpread: CGFloat = 0 {
        didSet {
            if shadowSpread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -shadowSpread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
