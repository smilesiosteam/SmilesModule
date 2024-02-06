//
//  AppHeaderView.swift
//  House
//
//  Created by Shahroze Zaheer on 10/27/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import LottieAnimationManager
import SmilesLocationHandler
import SmilesEasyTipView
import SmilesUtilities
import SmilesFontsManager

public protocol AppHeaderDelegate: AnyObject {
    func didTapOnBackButton()
    func didTapOnSearch()
    func didTapOnLocation()
    func segmentRightBtnTapped(index: Int)
    func segmentLeftBtnTapped(index: Int)
    func rewardPointsBtnTapped()
    func didTapOnBagButton()
}

public extension AppHeaderDelegate {
    func showPopupForLocationSetting(){}
    func didTapOnToolTipSearch(){}
    func locationUpdatedSuccessfully(){}
    func segmentLeftBtnTapped(index: Int) {}
    func segmentRightBtnTapped(index: Int) {}
    func didTapOnBagButton() {}
}

public class AppHeaderView: UIView {
    
    // MARK: -- Outlets
    
    @IBOutlet weak var topNavbarHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var locationView: UIStackView!
    @IBOutlet weak var locationNickName: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet public weak var headerTitleImageView: UIImageView!
    @IBOutlet weak var headerBackButton: UIButton!
    @IBOutlet weak var bottomCurveView: UIView!
    @IBOutlet weak var bottomCurveWithTabsView: UIView!

    @IBOutlet weak var bottomSegmentView: UIView!
    @IBOutlet weak var bottomSegment1Title: UILabel!
    @IBOutlet weak var bottomSegment2Title: UILabel!
    @IBOutlet weak var bottomSegment1Icon: UIImageView!
    @IBOutlet weak var bottomSegment1BottomBar: UIView!
    @IBOutlet weak var bottomSegment2Icon: UIImageView!
    @IBOutlet weak var bottomSegment2BottomBar: UIView!
    
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var bagButtonView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet public var view_container: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var pointsIconImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var locationArrowImageView: UIImageView!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchViewCompact: UIView!
    @IBOutlet weak var searchLabelCompact: UILabel!
    @IBOutlet weak var searchIconImageViewCompact: UIImageView!
    
    @IBOutlet public weak var bodyViewCompact: UIView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchIconImageView: UIImageView!
    @IBOutlet weak var lottieAnimationView: UIView!
    @IBOutlet weak var rewardPointsButton: UIButton!
    
    @IBOutlet public weak var promotionContainer: UIView!
    @IBOutlet public weak var promotionLabel: UILabel!
    
    @IBOutlet weak var backBtnBottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var headerBarHeight: NSLayoutConstraint!
    public weak var delegate: AppHeaderDelegate?
    var smilesLocationHandler : SmilesLocationHandler?
    var gradientLayer:CAGradientLayer? = nil
    var locationToolTip: EasyTipView?
    public var fireEvent: ((String) -> Void)?
    var isGuestUser = true
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        rewardPointsButton.setTitle("", for: .normal)
        setupBottomBarUI()
    }
    
    func commonInit() {
        _ = Bundle.module.loadNibNamed("AppHeaderView", owner: self, options: nil)?.first as? UIView
        addSubview(view_container)
        view_container.frame = bounds
        
        view_container.bindFrameToSuperviewBounds()
        
        
        lottieAnimationView.isHidden = true
        setupBottomBarUI()
    }
    
    func setupBottomBarUI(){
        bottomSegment1BottomBar.layer.cornerRadius = 14
        bottomSegment2BottomBar.layer.cornerRadius = 14
        promotionContainer.layer.cornerRadius = 9
        
        bottomSegment1BottomBar.clipsToBounds = true
        bottomSegment2BottomBar.clipsToBounds = true
        promotionContainer.clipsToBounds = true
    }
    
        
    public func setupHeaderView(backgroundColor: UIColor, searchBarColor: UIColor, pointsViewColor: UIColor?,  titleColor: UIColor, headerTitle: String, showHeaderNavigaton: Bool, topCurveShouldAdd: Bool = false, haveSearchBorder: Bool = false, shouldShowBag: Bool = false, isFirstLaunch: Bool = false, isGuestUser: Bool, showHeaderContent: Bool = true, toolTipInfo: ((SmilesLocationHandler?) -> (Bool,UIView))?) {
        self.isGuestUser = isGuestUser
        smilesLocationHandler = SmilesLocationHandler.init(controller: delegate as? UIViewController, isFirstLaunch: isFirstLaunch)
        smilesLocationHandler?.smilesLocationHandlerDelegate = self
        smilesLocationHandler?.fireEvent = fireEvent
        smilesLocationHandler?.showLocationToolTip = { [weak self] in
            guard let self, let toolTipInfo = toolTipInfo else { return }
            let (needToshow,contentVu) = toolTipInfo(self.smilesLocationHandler)
            if needToshow {
                self.smilesLocationHandler?.toolTipForLocationShown = true
                self.locationToolTip = EasyTipView(contentView: contentVu, preferences: EasyTipViewPreference.locationTipPreferences(), delegate: self.smilesLocationHandler as? EasyTipViewDelegate)
                self.locationToolTip?.show(forView: self.locationArrowImageView)
            }
        }
        smilesLocationHandler?.dismissLocationToolTip = { [weak self] in
            guard let self else { return }
            UIView.animate(withDuration: 0.2) {
                self.locationToolTip?.dismiss()
                self.smilesLocationHandler?.toolTipForLocationShown = false
            }
        }
//        NotificationCenter.default.removeObserver(self, name: .LocationUpdated, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdatedManually(_:)), name: .LocationUpdated, object: nil)
        
        
        view_container.backgroundColor = self.bodyViewCompact.isHidden ? backgroundColor : .white
        searchView.backgroundColor = searchBarColor
        searchViewCompact.backgroundColor = .appRevampHomeCompactSearchColor
        pointsView.backgroundColor = pointsViewColor ?? searchBarColor
        locationTitleLabel.textColor = titleColor
        locationNickName.textColor = titleColor
        pointsLabel.textColor = titleColor
        title.textColor = titleColor
        locationArrowImageView.image = locationArrowImageView.image?.withRenderingMode(.alwaysTemplate)
        locationArrowImageView.tintColor = titleColor
        title.text = headerTitle
        let searchLabelColor: UIColor = searchBarColor == .white ? .black.withAlphaComponent(0.6) : .appRevampBorderGrayColor
        searchLabel.textColor = searchLabelColor
        searchLabelCompact.textColor = .appRevampHomeSearchColor
        headerView.isHidden = !showHeaderNavigaton
        self.configureFonts()
        DispatchQueue.main.async {
            if topCurveShouldAdd {
                self.bottomCurveView.isHidden = false
                self.bottomCurveView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20)
            } else {
                self.bottomCurveView.isHidden = true
                self.bottomCurveWithTabsView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20)
            }
            self.backButtonView.RoundedViewConrner(cornerRadius: self.backButtonView.frame.height / 2)
            
            self.pointsView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: 16.0)
            
            self.searchView.RoundedViewConrner(cornerRadius: 12.0)
            self.searchViewCompact.RoundedViewConrner(cornerRadius: 12.0)
            self.searchIconImageView.image = UIImage(named: "searchRevampIcon")?.withTintColor(searchLabelColor, renderingMode: .alwaysOriginal)
            self.searchIconImageViewCompact.image = UIImage(named: "searchRevampIcon")?.withTintColor(.appRevampHomeSearchColor, renderingMode: .alwaysOriginal)
            self.lottieAnimationView.RoundedViewConrner(cornerRadius: self.lottieAnimationView.bounds.height / 2)
        }
        
        if haveSearchBorder {
            searchView.layer.borderWidth = 1.0
            searchView.layer.borderColor = UIColor.appRevampBorderGrayColor.cgColor
        }
        
        if !isGuestUser {
            bagButtonView.isHidden = !shouldShowBag
        } else {
            bagButtonView.isHidden = true
//            pointsView.isHidden = true
//            lottieAnimationView.isHidden = true
            rewardPointsButton.isEnabled = false
        }
        
        if AppCommonMethods.languageIsArabic() {
            headerBackButton.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        if isGuestUser {
            pointsLabel.text = "0"
            pointsIconImageView.isHidden = false
            pointsIconImageView.image = UIImage(named: "smileyHearts")
        }
        
        if !showHeaderContent {
            bodyView.isHidden = true
            bodyViewCompact.isHidden = true
        }
        
        if !hasTopNotch {
            self.topNavbarHeightConst.constant = 30
        }
        
    }
    
    
    
    public func configureFonts() {
        self.title.fontTextStyle = .smilesTitle1
        self.locationNickName.fontTextStyle = .smilesTitle1
        self.locationTitleLabel.fontTextStyle = .smilesTitle3
        self.pointsLabel.fontTextStyle = .smilesHeadline3
        self.searchLabel.font = .circularXXTTBookFont(size: 16)
        self.searchLabelCompact.font = .circularXXTTBookFont(size: 16)
        self.promotionLabel.fontTextStyle = .smilesTitle3
    }
    
    public func setBottomSegment(title1: String?, icon1: UIImage?, title2: String?, icon2: UIImage?, shouldShowSegment: Bool, isPayBillsView: Bool = false) {
        if shouldShowSegment {
            self.bottomCurveView.isHidden = true
            self.bottomSegmentView.isHidden = false
            self.bottomSegment1Title.text = title1
            self.bottomSegment1Title.fontTextStyle = .smilesTitle1
            self.bottomSegment1Icon.isHidden = false
            self.bottomSegment1Icon.tintColor = isPayBillsView ? .foodEnableColor : .appRevampFoodDisableIconGrayColor
            self.bottomSegment1Icon.image = icon1
            self.bottomSegment2Title.text = title2
            self.bottomSegment2Title.fontTextStyle = .smilesTitle1
            self.bottomSegment2Icon.isHidden = false
            self.bottomSegment2Icon.tintColor = isPayBillsView ? .appRevampFoodDisableIconGrayColor : .foodEnableColor
            self.bottomSegment2Icon.image = icon2
            buttonStatus(isButton1Selected: isPayBillsView)
        }
    }
    
    public func setBottomSegmentForFood(title1: String?, icon1: UIImage?, title2: String?, icon2: UIImage?, shouldShowSegment: Bool, isFromPickup: Bool = false) {
        if shouldShowSegment {
            self.bottomCurveView.isHidden = true
            self.bottomSegmentView.isHidden = false
            self.bottomSegment1Title.text = title1
            self.bottomSegment1Title.fontTextStyle = .smilesTitle1
            self.bottomSegment1Icon.isHidden = false
            self.bottomSegment1Icon.tintColor = isFromPickup ? .appRevampFoodDisableIconGrayColor : .foodEnableColor
            self.bottomSegment1Icon.image = icon1
            self.bottomSegment2Title.text = title2
            self.bottomSegment2Title.fontTextStyle = .smilesTitle1
            self.bottomSegment2Icon.isHidden = false
            self.bottomSegment2Icon.tintColor = isFromPickup ? .foodEnableColor : .appRevampFoodDisableIconGrayColor
            self.bottomSegment2Icon.image = icon2
            buttonStatus(isButton1Selected: !isFromPickup)
        }
    }
    
    public func gradiantColor(with colors: [CGColor], for direction: String?) {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = GradientUtility.shared.getGradientLayer(forView: view_container,
                                                                    colors: colors,
                                                                    direction: direction ?? "top")
        view_container.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    public func setBackgroundColor(_ color: UIColor?) {
        view_container.backgroundColor = color
    }
    
    public func setCustomImageForBackButton(imageName: String) {
        if let image = UIImage(named: imageName, in: Bundle.module, compatibleWith: nil) {
            self.headerBackButton.setImage(image, for: .normal)
            self.headerBackButton.backgroundColor = .clear
            self.backButtonView.backgroundColor = .clear
        }
    }
    
    public func setPointsIcon(with iconURL: String?, shouldShowAnimation: Bool = true) {
        if let iconJsonAnimationUrl = iconURL, !iconJsonAnimationUrl.isEmpty {
            lottieAnimationView.addBorder(withBorderWidth: 1.0, borderColor: .black.withAlphaComponent(0.1))
            lottieAnimationView.isHidden = false
            pointsIconImageView.isHidden = true
            lottieAnimationView.subviews.forEach({ $0.removeFromSuperview() })
            if let url = URL(string: iconJsonAnimationUrl) {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: url, animationBackgroundView: self.lottieAnimationView, removeFromSuper: false, loopMode: .playOnce, shouldAnimate: shouldShowAnimation) { _ in }
            }
        } else {
            pointsIconImageView.isHidden = false
            lottieAnimationView.isHidden = true
        }
    }
    
    public func setPointsOfUser(with userPoints: String?) {
        if !isGuestUser {
            pointsLabel.text = userPoints ?? "0"
        } else {
            pointsLabel.text = "0"
        }
    }
    
    public func setLocation(locationName: String, locationNickName: String) {
    print("------ locationName \(locationName)0000000 locationNickName ---- \(locationNickName)")
        
        if locationNickName.isEmpty || locationNickName == "" {
            self.locationNickName.text = "CurrentLocation".localizedString
        } else {
            self.locationNickName.text = locationNickName.upperCamelCased
        }
        self.locationTitleLabel.text = locationName
        
        if isGuestUser && !LocationManager.shared.isEnabled() {
            locationView.isHidden = true
        } else {
            locationView.isHidden = false
        }
    }
    
    public func setSearchText(with searchText: String?) {
        searchLabel.text = searchText ?? ""
        searchLabelCompact.text = searchText ?? ""
    }
    
    public func setHeaderTitle(title: String?) {
        self.title.text = title
    }
    
    public func setHeaderTitleIcon(iconURL: String?) {
        self.headerTitleImageView.setImageWithUrlString(iconURL ?? "", defaultImage: "")
    }
    public func adjustUI(compact:Bool, isBackgroundColorClear:Bool = false){
        backBtnBottomSpace.constant = compact ? 8 : 22
        headerBarHeight.constant = compact ? 40 : 54
        if isBackgroundColorClear == false {
            backButtonView.backgroundColor = compact ? .appRevampHomeCompactSearchColor : .white
        }
        UIView.transition(with: !bodyView.isHidden ? bodyView : bodyViewCompact, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve){
            self.bodyView.isHidden = compact
            self.bodyViewCompact.isHidden = !compact
            self.layoutIfNeeded()
        }
    }
    public func setBackgroundColorForCurveView(color: UIColor?) {
        bottomCurveView?.backgroundColor = color
    }
    
    public func setBackgroundColorForTabsCurveView(color: UIColor?) {
        bottomCurveWithTabsView.backgroundColor = color
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        delegate?.didTapOnBackButton()
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        if !isGuestUser {
            delegate?.didTapOnLocation()
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        delegate?.didTapOnSearch()
    }
    
    @IBAction func didLeftBtnTapped(_ sender: Any) {
        delegate?.segmentLeftBtnTapped(index: 0)
        buttonStatus(isButton1Selected: true)
    }
    
    @IBAction func didRightBtnTapped(_ sender: Any) {
        delegate?.segmentRightBtnTapped(index: 1)
        buttonStatus(isButton1Selected: false)
    }
    
    @IBAction func bagButtonTapped(_ sender: UIButton) {
        delegate?.didTapOnBagButton()
    }
    
    public func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "AppHeaderView", bundle: Bundle.module)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @objc public func locationUpdatedManually(_ notification: Notification) {
        smilesLocationHandler?.locationUpdatedManually(notification)
    }
    
    
    public func buttonStatus(isButton1Selected: Bool) {
        if isButton1Selected {
            bottomSegment1Icon.image = bottomSegment1Icon.image?.imageWithColor(color1: .foodEnableColor)
            bottomSegment1Title.textColor = .foodEnableColor
            bottomSegment1BottomBar.backgroundColor = .foodEnableColor
            bottomSegment1BottomBar.isHidden = false
            
            bottomSegment2Icon.image = bottomSegment2Icon.image?.imageWithColor(color1: .appRevampFoodDisableIconGrayColor)
            bottomSegment2Title.textColor = .appRevampFoodDisableTextGrayColor
            bottomSegment2BottomBar.isHidden = true
        } else {
            bottomSegment1Icon.image = bottomSegment1Icon.image?.imageWithColor(color1: .appRevampFoodDisableIconGrayColor)
            bottomSegment1Title.textColor = .appRevampFoodDisableTextGrayColor
            bottomSegment1BottomBar.isHidden = true
            
            bottomSegment2Icon.image = bottomSegment2Icon.image?.imageWithColor(color1: .foodEnableColor)
            bottomSegment2Title.textColor = .foodEnableColor
            bottomSegment2BottomBar.backgroundColor = .foodEnableColor
            bottomSegment2BottomBar.isHidden = false
        }
    }
    
    @IBAction func rewardPointsTapped(_ sender: UIButton) {
        self.delegate?.rewardPointsBtnTapped()
    }
}


extension AppHeaderView : SmilesLocationHandlerDelegate{
    public func showPopupForLocationSetting() {
        self.delegate?.showPopupForLocationSetting()
    }
    
    public func searchBtnTappedOnToolTip() {
        self.delegate?.didTapOnToolTipSearch()
    }
    
    public func getUserLocationWith(locationName: String, andLocationNickName: String) {
        self.setLocation(locationName: locationName, locationNickName: andLocationNickName)
    }
    
    public func locationUpdatedSuccessfully(){
        self.delegate?.locationUpdatedSuccessfully()
    }
}
