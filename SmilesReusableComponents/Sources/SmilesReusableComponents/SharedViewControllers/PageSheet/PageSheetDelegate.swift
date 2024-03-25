//
//  File.swift
//  
//
//  Created by Habib Rehman on 04/03/2024.
//

import Foundation
import UIKit

public protocol PageSheetDelegate: AnyObject {
    func didSelectLeftButton()
    func didSelectRightButton()
}


public func activateConstraints(subView: UIView, superView: UIView, constant: Int? = nil){
    NSLayoutConstraint.activate([
        subView.topAnchor.constraint(equalTo: superView.topAnchor),
        subView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
        subView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
        subView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
    ])
}
