//
//  TopOffersCollectionViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 27/07/2023.
//

import UIKit
import LottieAnimationManager

class TopOffersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lottieAnimationView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        lottieAnimationView.isHidden = true
    }
    
    func configureCell(with bannerImage: String, animationURL: String?) {
        lottieAnimationView.subviews.forEach({ $0.removeFromSuperview() })

        if let animationJsonURL = animationURL, !animationJsonURL.isEmpty {
            lottieAnimationView.isHidden = false
            image.isHidden = true
            if let url = URL(string: animationJsonURL) {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: url, animationBackgroundView: self.lottieAnimationView, removeFromSuper: false, loopMode: .loop) { (bool) in
                    
                }
            }
            
        } else {
            image.isHidden = false
            lottieAnimationView.isHidden = true
            if !bannerImage.isEmpty {
                self.image.setImageWithUrlString(bannerImage) { image in
                    if let image = image {
                        self.image.image = image
                    }
                }
            }
        }
        
        self.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 12.0)
    }

}
