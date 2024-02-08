//
//  SmilesExplorerMembershipSuccessViewController.swift
//  
//
//  Created by Ghullam  Abbas on 15/08/2023.
//

import UIKit
import SmilesUtilities
import Combine
import LottieAnimationManager
import SmilesLanguageManager
import SmilesFontsManager
import SmilesLoader

public enum SourceScreen {
    case success
    case freePassSuccess
}

public class SmilesExplorerMembershipSuccessViewController: UIViewController {
    
    // MARK: - IBOutlets -
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var linkArrowImageView: UIImageView!
    @IBOutlet weak var congratulationLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateORLinkButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var exploreButton: UIButton!
    
    // MARK: - Properties -
    var transactionId: String?
    private var onContinue:((String?) -> Void)?
    private var onGoToExplorer:(() -> Void)?
   // private var model: SmilesExplorerSubscriptionInfoResponse?
    
    lazy  var backButton: UIButton = UIButton(type: .custom)
    var membershipPicked:((BOGODetailsResponseLifestyleOffer)->Void)? = nil
    
    private let sourceScreen: SourceScreen
    private var response: SmilesExplorerSubscriptionInfoResponse?
    private var input: PassthroughSubject<SmilesExplorerMembershipSelectionViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesExplorerMembershipSelectionViewModel = {
        return SmilesExplorerMembershipSelectionViewModel()
    }()
    private var offerTitle: String
    private var packageType: String?
    // MARK: - ViewController Lifecycle -
   
    public override func viewDidLoad() {
        super.viewDidLoad()
            styleFontAndTextColor()
        bind(to: viewModel)
        input.send(.getSubscriptionInfo())
        // Do any additional setup after loading the view.
    }
    // MARK: - Methods -
    init(_ sourceScreen: SourceScreen,packageType: String? ,transactionId: String?,offerTitle: String,onContinue: ((String?) -> Void)?,onGoToExplorer: (() -> Void)?) {
        self.packageType = packageType
        self.transactionId = transactionId
        self.onGoToExplorer = onGoToExplorer
        self.onContinue = onContinue
        self.sourceScreen = sourceScreen
        self.offerTitle = offerTitle
        super.init(nibName: "SmilesExplorerMembershipSuccessViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func bind(to viewModel: SmilesExplorerMembershipSelectionViewModel) {
        input = PassthroughSubject<SmilesExplorerMembershipSelectionViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSubscriptionInfoDidSucceed(response: let response):
                    self?.response = response
                    self?.setupUI()
                    
                case .fetchSubscriptionInfoDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func setUpNavigationBar(_ showBackButton: Bool = false) {
       
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        let locationNavBarTitle = UILabel()
        if self.sourceScreen == .freePassSuccess {
            locationNavBarTitle.text = self.response?.themeResources?.explorerSubscriptionTitle ?? "success".localizedString
        } else {
            locationNavBarTitle.text = "success".localizedString
        }
        
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        locationNavBarTitle.textColor = .appRevampPurpleMainColor
        

        self.navigationItem.titleView = locationNavBarTitle
        /// Back Button Show
        
            self.backButton = UIButton(type: .custom)
            // btnBack.backgroundColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
            self.backButton.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "purple_back_arrow_ar" : "purple_back_arrow", in: .module, compatibleWith: nil), for: .normal)
            self.backButton.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
            self.backButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            self.backButton.layer.cornerRadius = self.backButton.frame.height / 2
            self.backButton.clipsToBounds = true
            
            let barButton = UIBarButtonItem(customView: self.backButton)
            self.navigationItem.leftBarButtonItem = barButton
        if (!showBackButton) {
            self.backButton.isHidden = true
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
    }
    private func styleFontAndTextColor() {
       
        self.congratulationLabel.fontTextStyle = .smilesHeadline3
        self.detailLabel.fontTextStyle = .smilesBody1
        self.dateORLinkButton.fontTextStyle = .smilesBody3
        self.continueButton.fontTextStyle = .smilesHeadline4
        self.exploreButton.fontTextStyle = .smilesHeadline4
        self.detailLabel.textColor = .appDarkGrayColor
        self.congratulationLabel.textColor = .appDarkGrayColor
        self.dateORLinkButton.titleLabel?.textColor = .appRevampSubtitleColor
        
    }
    
    private func setupUI() {
        self.setUpNavigationBar(self.sourceScreen == .freePassSuccess ? true: false)
        setButtonsAndDateORLinkUI()
        
        continueButton.setTitle( "ContinueTitle".localizedString.capitalized, for: .normal)
        self.exploreButton.setTitle("ContinueTitle".localizedString.capitalized, for: .normal)
        congratulationLabel.text = self.response?.themeResources?.explorerPurchaseSuccessTitle
        if let urlStr = self.response?.themeResources?.explorerPurchaseSuccessImage, !urlStr.isEmpty {
            imgView.isHidden = false
            if urlStr.hasSuffix(".json"), let url = URL(string:urlStr) {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: url, animationBackgroundView: self.imgView, removeFromSuper: false, loopMode: .loop, shouldAnimate: true) { _ in }
            }else{
                self.imgView.setImageWithUrlString(urlStr)
            }
        } else {
            imgView.isHidden = true
        }
        var detailMessage = ""
        if (sourceScreen == .success) {
            detailMessage = self.response?.themeResources?.passPurchaseSuccessMsg ?? ""
            detailMessage =   detailMessage.replacingOccurrences(of:"<<OFFER_TITLE>>" , with: offerTitle)
        } else {
            detailMessage = self.response?.themeResources?.ticketPurchaseSuccessMsg ?? ""
            detailMessage =   detailMessage.replacingOccurrences(of:"<<OFFER_TITLE>>" , with: offerTitle)
        }
        detailLabel.text = detailMessage
        
        
    }
    func setButtonsAndDateORLinkUI() {
        
        switch self.sourceScreen {
        case.freePassSuccess:
            self.backButton.isHidden = false
            self.exploreButton.isHidden = false
            self.continueButton.isHidden = true
//            let underLineAttributes: [NSAttributedString.Key: Any] = [
//                .font: SmilesFonts.lato.getFont(style: .medium, size: 16) ,
//                  .foregroundColor: UIColor.appRevampFilterCountBGColor,
//                  .underlineStyle: NSUnderlineStyle.single.rawValue
//              ] //
//            let attributeString = NSMutableAttributedString(
//                string: "View free pass".localizedString,
//                    attributes: underLineAttributes
//                 )
            self.dateORLinkButton.fontTextStyle = .smilesHeadline4
            self.dateORLinkButton.setTitle("View free pass".localizedString, for: .normal)
            self.dateORLinkButton.setTitleColor(UIColor(red: 66/255.0, green: 76/255.0, blue: 156/255.0 , alpha: 1), for: .normal)
            self.dateORLinkButton.isUserInteractionEnabled = true
            self.linkArrowImageView.isHidden = false
        case.success:
            self.backButton.isHidden = true
            self.exploreButton.isHidden = true
            self.continueButton.isHidden = false
            for item in self.response?.lifestyleOffers ?? [] {
                if (item.packageType == self.packageType) {
                    if let expiryDateString =  item.expiryDate {
                        let outputDateString = expiryDateString.convertDate(from: "dd-MM-yyyy HH:mm:ss", to: "dd MMMM, YYYY")
                        let finalDateString = "*" + "Valid til".localizedString + " " + outputDateString
                        dateORLinkButton.setTitle(finalDateString, for: .normal)
                    }
                }
            }
            
            
        }
        self.exploreButton.titleLabel?.textColor = .appRevampPurpleMainColor

    }
    
    // MARK: - IBActions -
    @IBAction func viewFreePassDidTab(_ sender: UIButton) {
        if let id = self.transactionId {
            self.onContinue?(id)
        }
    }
    @IBAction func continueButtonDidTab(_ sender: UIButton) {
        self.onContinue?(nil)
    }
    @IBAction func exploreButtonDidTab(_ sender: UIButton) {
        self.onGoToExplorer?()
    }
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
