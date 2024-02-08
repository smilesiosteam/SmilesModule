//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 02/10/2023.
//

import Foundation
import UIKit

@IBDesignable
public class SZGradientView: UIImageView {
    private let gradientLayer = CAGradientLayer()
    private var colors: [CGColor]!
    private var locations: [NSNumber]!
    
    @IBInspectable public var direction: UInt = 1 {
        didSet{
            configure()
        }
    }
    
    func setup() {
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configure(){
        gradientLayer.cornerRadius = 0
        gradientLayer.frame = bounds
        guard let colors = self.colors else {return}
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y:0 )
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        guard let locations = self.locations else {return}
        gradientLayer.locations = locations

        switch direction % 5 {
        case 0:
            gradientLayer.startPoint = CGPoint(x: 0, y:0 )
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        case 1:
            gradientLayer.startPoint = CGPoint(x: 0, y:0 )
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        case 2:
            gradientLayer.startPoint = CGPoint(x: 0, y:0 )
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        case 3:
            gradientLayer.startPoint = CGPoint(x: 1, y:0 )
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        case 4:
            gradientLayer.startPoint = CGPoint(x: 1, y:1 )
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        default:
            gradientLayer.startPoint = CGPoint(x: 1, y:0 )
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public override func prepareForInterfaceBuilder() {
        setup()
        configure()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        configure()
    }
    
    public func updateColors(locations: [NSNumber], colors: [CGColor]) {
        self.locations = locations
        self.colors = colors
        configure()
    }
}

