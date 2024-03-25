//
//  File.swift
//
//
//  Created by Habib Rehman on 04/03/2024.
//

import Foundation
import UIKit
import SmilesUtilities

public class PageSheetView: UIView {
    
    public var containerView: UIView!
    private var pageSheetViewController: PageSheetViewController!
    private var blackBackgroundView: UIView!
    weak var delegate: PageSheetDelegate?
    // Initialize the resizable page sheet view
    
    public init(delegate: PageSheetDelegate? = nil, pageSheetModel: ConsentConfigDO? = nil) {
        super.init(frame: .zero)
        setupSubviews(delegate: delegate, pageSheetModel: pageSheetModel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews(delegate: PageSheetDelegate? = nil, pageSheetModel: ConsentConfigDO? = nil) {
        
        blackBackgroundView = UIView()
        blackBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        blackBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blackBackgroundView)
        
        // Add constraints to the black background view
        activateConstraints(subView: blackBackgroundView, superView: self)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        let dragToDismissGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        blackBackgroundView.addGestureRecognizer(dragToDismissGesture)
        blackBackgroundView.addGestureRecognizer(tapGesture)
        containerView = UIView()
        addSubview(containerView)
        
        // Add constraints to the container view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 230) // Initial height
        ])
        // Initialize the page sheet view controller
        pageSheetViewController = PageSheetViewController(delegate: delegate, pageSheetModel: pageSheetModel)
        pageSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageSheetViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        pageSheetViewController.view.layer.cornerRadius = 16.0
        containerView.addSubview(pageSheetViewController.view)
        activateConstraints(subView: pageSheetViewController.view, superView: containerView)
        
    }
    
    @objc func dismissTapped() {
        self.removeFromSuperview()
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let velocity = recognizer.velocity(in: self)
        
        switch recognizer.state {
        case .changed:
            if translation.y > 0 {
                self.frame.origin.y = translation.y
            }
        case .ended:
            if translation.y > 100 || velocity.y > 500 {
                self.removeFromSuperview()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.frame.origin.y = 0
                }
            }
        default:
            break
        }
    }
    
    // Update the height of the container view based on content size
    public func updateContainerHeight() {
        pageSheetViewController.view.layoutIfNeeded() // Ensure layout is updated
        let totalContentHeight = pageSheetViewController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        containerView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = totalContentHeight
            }
        }
    }
}
