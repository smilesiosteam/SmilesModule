//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 05/07/2023.
//

import UIKit
import SmilesSharedServices
import SmilesUtilities
import SmilesFontsManager


public class FAQTableViewCell: UITableViewCell{

    // MARK: - OUTLETS -
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dropdownImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: - Properties -
    public static let module = Bundle.module
    public var bottomViewIsHidden: Bool = false {
        didSet {
            self.bottomView.isHidden = bottomViewIsHidden
        }
    }
    
    // MARK: - LIFECYCLE -
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    public func setupCell(model:FaqsDetail) {
        
        titleLabel.text = model.faqTitle
        descriptionLabel.attributedText(model.faqContent.asStringOrEmpty().htmlToAttributedString,
                                        style: .smilesBody2,
                                        alignment: AppCommonMethods.languageIsArabic() ? .right : .left)
        dropdownImageView.image = UIImage(named: (model.isHidden ?? true) ? "faq_dropdown" : "faq_collapse",
                                          in: .module, compatibleWith: nil)
        titleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        
    }
    
    
    
    
}
