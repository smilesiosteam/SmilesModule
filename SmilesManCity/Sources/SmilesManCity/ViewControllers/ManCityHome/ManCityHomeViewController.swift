//
//  ManCityHomeViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 26/06/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices
import Combine
import SmilesOffers
import SmilesStoriesManager
import SmilesBanners
import SmilesReusableComponents

public class ManCityHomeViewController: UIViewController {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var tableViewTopSpaceToHeaderView: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopSpaceToSuperView: NSLayoutConstraint!
    
    // MARK: - PROPERTIES -
    var dataSource: SectionedTableViewDataSource?
    private var input: PassthroughSubject<ManCityHomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: ManCityHomeViewModel = {
        return ManCityHomeViewModel()
    }()
    private let categoryId: Int
    public weak var delegate: ManCityHomeDelegate?
    var manCitySections: GetSectionsResponseModel?
    var sections = [TableSectionData<ManCityHomeSectionIdentifier>]()
    var isUserSubscribed: Bool? = nil
    var aboutVideoUrl: String?
    var username: String?
    
    private var subscriptionInfo: SubscriptionInfoResponse?
    private var userData: RewardPointsResponseModel?
    private var selectedIndexPath: IndexPath?
    private var offerFavoriteOperation = 0 // Operation 1 = add and Operation 2 = remove
    var offersPage = 1 // For offers list pagination
    var offers = [OfferDO]()
    
    // MARK: - ACTIONS -
    
    
    // MARK: - VIEW LIFECYCLE -
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar(isLightContent: tableViewTopSpaceToSuperView.priority != .defaultHigh)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public init(categoryId: Int, isUserSubscribed: Bool? = nil, aboutVideoUrl: String? = nil, username: String?) {
        self.categoryId = categoryId
        self.isUserSubscribed = isUserSubscribed
        self.aboutVideoUrl = aboutVideoUrl
        self.username = username
        super.init(nibName: "ManCityHomeViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - METHODS -
    private func setupViews() {
        
        setupTableView()
        bind(to: viewModel)
        getSections()
        
    }
    
    private func setupTableView() {
        contentTableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            contentTableView.sectionHeaderTopPadding = CGFloat(0)
        }
        contentTableView.sectionHeaderHeight = UITableView.automaticDimension
        contentTableView.estimatedSectionHeaderHeight = 1
        contentTableView.delegate = self
        let manCityCellRegistrable: CellRegisterable = ManCityHomeCellRegistration()
        manCityCellRegistrable.register(for: contentTableView)
        
    }
    
    fileprivate func configureDataSource() {
        self.contentTableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
    
    private func configureSectionsData(with sectionsResponse: GetSectionsResponseModel) {
        manCitySections = sectionsResponse
        setUpNavigationBar()
        if let sectionDetailsArray = sectionsResponse.sectionDetails, !sectionDetailsArray.isEmpty {
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: sectionDetailsArray.count))
        }
        if let topPlaceholderSection = sectionsResponse.sectionDetails?.first(where: { $0.sectionIdentifier == ManCityHomeSectionIdentifier.topPlaceholder.rawValue }) {
            headerImageView.setImageWithUrlString(topPlaceholderSection.backgroundImage ?? "")
        }
    
        if let isUserSubscribed {
            if !isUserSubscribed {
                setupPreEnrollmentUI()
            } else {
                setupPostEnrollmentUI()
            }
        } else {
            self.input.send(.getRewardPoints)
        }
        
    }
    
    func getSectionIndex(for identifier: ManCityHomeSectionIdentifier) -> Int? {
        
        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index
        
    }
    
    private func setupPreEnrollmentUI() {
        
        self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 2))
        self.sections.removeAll()
        self.sections.append(TableSectionData(index: 0, identifier: .enrollment))
        self.sections.append(TableSectionData(index: 1, identifier: .FAQS))
        if let enrollmentIndex = getSectionIndex(for: .enrollment), let response = SubscriptionInfoResponse.fromModuleFile() {
            dataSource?.dataSources?[enrollmentIndex] = TableViewDataSource.make(forEnrollment: response, data: "#FFFFFF", isDummy: true, completion: nil)
        }
        if let faqsIndex = getSectionIndex(for: .FAQS), let response = FAQsDetailsResponse.fromModuleFile() {
            dataSource?.dataSources?[faqsIndex] = TableViewDataSource.make(forFAQs: response.faqsDetails ?? [], data: "#FFFFFF", isDummy: true, completion: nil)
        }
        configureDataSource()
        self.input.send(.getSubscriptionInfo)
        self.input.send(.getFAQsDetails(faqId: 9))
        
    }
    
    private func setupPostEnrollmentUI() {
        self.contentTableView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
        self.contentTableView.backgroundColor = .white
        self.sections.removeAll()
        self.manCityHomeAPICalls()
    }
    
    func setUpNavigationBar(isLightContent: Bool = true) {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = isLightContent ? .clear : UIColor(hex: "ECEDF5")
        if isLightContent {
            appearance.configureWithTransparentBackground()
        }
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        guard let headerData = manCitySections?.sectionDetails?.first(where: { $0.sectionIdentifier == ManCityHomeSectionIdentifier.topPlaceholder.rawValue }) else { return }
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.tintColor = isLightContent ? .white : .black
        imageView.sd_setImage(with: URL(string: headerData.iconUrl ?? "")) { image, _, _, _ in
            imageView.image = image?.withRenderingMode(.alwaysTemplate)
        }

        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = headerData.title
        locationNavBarTitle.textColor = isLightContent ? .white : .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [imageView, locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack
        
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.backgroundColor = .white
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_icon_ar" : "back_icon", in: .module, compatibleWith: nil), for: .normal)
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnBack.layer.cornerRadius = btnBack.frame.height / 2
        btnBack.clipsToBounds = true
        btnBack.tintColor = .black
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - VIEWMODEL BINDING -
extension ManCityHomeViewController {
    
    func bind(to viewModel: ManCityHomeViewModel) {
        input = PassthroughSubject<ManCityHomeViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    self?.configureSectionsData(with: sectionsResponse)
                    
                case .fetchSectionsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchSubscriptionInfoDidSucceed(response: let response):
                    self?.configureEnrollment(with: response)
                    
                case .fetchSubscriptionInfoDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchRewardPointsDidSucceed(response: let response, _):
                    self?.aboutVideoUrl = response.mcfcWelcomeVideoUrl
                    if response.mcfcSubscriptionStatus ?? false {
                        self?.setupPostEnrollmentUI()
                    } else {
                        self?.setupPreEnrollmentUI()
                    }
                    
                case .fetchRewardPointsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchFAQsDidSucceed(response: let response):
                    self?.configureFAQsDetails(with: response)
                    
                case .fetchFAQsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchQuickAccessListDidSucceed(let response):
                    self?.configureQuickAccessList(with: response)
                    
                case .fetchQuickAccessListDidFail(let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchOffersCategoryListDidSucceed(let response):
                    self?.configureManCityOffers(with: response)
                    
                case .fetchOffersCategoryListDidFail(let error):
                    debugPrint(error.localizedDescription)
                    
                case .emptyOffersListDidSucceed:
                    self?.offersPage = 1
                    self?.offers.removeAll()
                    self?.configureDataSource()
                    
                case .updateWishlistStatusDidSucceed(let updateWishlistResponse):
                    self?.configureWishListData(with: updateWishlistResponse)
                    
                case .updateWishlistStatusDidFail(let error):
                    print(error.localizedDescription)
                case .fetchTopOffersDidSucceed(response: let response):
                    self?.configureBannersData(with: response)
                    
                default: break
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: - SERVICE CALLS -
extension ManCityHomeViewController {
    
    private func getSections() {
        self.input.send(.getSections(categoryID: categoryId))
    }
    
    private func manCityHomeAPICalls() {
        
        if let sectionDetails = self.manCitySections?.sectionDetails, !sectionDetails.isEmpty {
            sections.removeAll()
            for (index, element) in sectionDetails.enumerated() {
                guard let sectionIdentifier = element.sectionIdentifier, !sectionIdentifier.isEmpty else {
                    return
                }
                if let section = ManCityHomeSectionIdentifier(rawValue: sectionIdentifier), section != .topPlaceholder {
                    sections.append(TableSectionData(index: index, identifier: section))
                }
                switch ManCityHomeSectionIdentifier(rawValue: sectionIdentifier) {
                case .quickAccess:
                    self.input.send(.getQuickAccessList(categoryId: self.categoryId))

                case .offerListing:
                    if let offersCategory = OffersCategoryResponseModel.fromFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forNearbyOffers: offersCategory.offers ?? [], data: "#FFFFFF", isDummy: true, completion: nil)
                    }
                    
                    self.input.send(.getOffersCategoryList(pageNo: self.offersPage, categoryId: "\(self.categoryId)", searchByLocation: false, sortingType: "", subCategoryId: "", subCategoryTypeIdsList: []))
                case .about:
                    if let aboutVideo = AboutVideo.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forAboutVideo: aboutVideo, data: "#FFFFFF", isDummy: true)
                    }
                    
                    self.configureAboutVideo(with: self.aboutVideoUrl ?? "")
                case .inviteFriends, .updates:
                    if let response = GetTopOffersResponseModel.fromFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forTopOffers: response, data:"#FFFFFF", isDummy: true, completion:nil)
                    }
                    self.input.send(.getTopOffers(bannerType: sectionIdentifier, categoryId: categoryId))
                default: break
                }
            }
        }
    }
}

// MARK: - TABLEVIEW DATASOURCE CONFIGURATION -
extension ManCityHomeViewController {
    
    private func configureEnrollment(with response: SubscriptionInfoResponse) {
        self.subscriptionInfo = response
        if let enrollmentIndex = getSectionIndex(for: .enrollment) {
            dataSource?.dataSources?[enrollmentIndex] = TableViewDataSource.make(forEnrollment: response, data: "#FFFFFF", isDummy: false, completion: { [weak self] in
                guard let self else {return}
                ManCityRouter.shared.pushUserDetailsVC(navVC: self.navigationController!, userData: self.userData, viewModel: self.viewModel) { (playerId, referralCode, hasAttendedManCityGame) in
                    guard let offer = self.subscriptionInfo?.lifestyleOffers?.first else { return }
                    self.delegate?.proceedToPayment(params: ManCityPaymentParams(lifeStyleOffer: offer, playerID: playerId, referralCode: referralCode, hasAttendedManCityGame: hasAttendedManCityGame, appliedPromoCode: nil, priceAfterPromo: nil, themeResources: nil, isComingFromSpecialOffer: false, isComingFromTreasureChest: false))
                }
            })
            configureDataSource()
        }
    }
    
    private func configureFAQsDetails(with response: FAQsDetailsResponse) {
        if let faqIndex = getSectionIndex(for: .FAQS) {
            dataSource?.dataSources?[faqIndex] = TableViewDataSource.make(forFAQs: response.faqsDetails ?? [], data: "#FFFFFF", completion: nil)
            configureDataSource()
        }
    }
    
    private func configureQuickAccessList(with response: QuickAccessResponseModel) {
        if let quickAccessLinks = response.quickAccess?.links, !quickAccessLinks.isEmpty {
            var quickAccessResponse = response
            if let quickAccessSection = manCitySections?.sectionDetails?.first(where: { $0.sectionIdentifier == ManCityHomeSectionIdentifier.quickAccess.rawValue }) {
                quickAccessResponse.quickAccess?.iconUrl = quickAccessSection.iconUrl
            }
            if let quickAccessIndex = getSectionIndex(for: .quickAccess) {
                dataSource?.dataSources?[quickAccessIndex] = TableViewDataSource.make(forQuickAccess: quickAccessResponse, data: "#FFFFFF", completion: { quickAccessLink in
                    if let subCategoryId = quickAccessLink.redirectionUrl?.components(separatedBy: "/").last as? String {
                        self.delegate?.navigateToCategoryDetails(subCategoryId: Int(subCategoryId) ?? 218)
                    }
                })
                
                configureDataSource()
            }
        } else {
            configureHideSection(for: .quickAccess, dataSource: QuickAccessResponseModel.self)
        }
    }
    
    private func configureAboutVideo(with url: String) {
        if !url.isEmpty {
            if let aboutVideoIndex = getSectionIndex(for: .about) {
                let aboutVideo = AboutVideo(videoUrl: url)
                dataSource?.dataSources?[aboutVideoIndex] = TableViewDataSource.make(forAboutVideo: aboutVideo, data: manCitySections?.sectionDetails?[aboutVideoIndex].backgroundColor ?? "#FFFFFF")
                configureDataSource()
            }
        } else {
            configureHideSection(for: .about, dataSource: AboutVideo.self)
        }
    }
    
    private func configureManCityOffers(with response: OffersCategoryResponseModel) {
        let offers = getAllOffers(offersCategoryListResponse: response)
        if !offers.isEmpty {
            if let manCityOffersIndex = getSectionIndex(for: .offerListing) {
                self.dataSource?.dataSources?[manCityOffersIndex] = TableViewDataSource.make(forNearbyOffers: offers, offerCellType: .manCity, data: self.manCitySections?.sectionDetails?[manCityOffersIndex].backgroundColor ?? "#FFFFFF"
                ) { [weak self] isFavorite, offerId, indexPath in
                    
                    self?.selectedIndexPath = indexPath
                    self?.updateOfferWishlistStatus(isFavorite: isFavorite, offerId: offerId)
                }
                self.configureDataSource()
            }
        } else {
            if offers.isEmpty {
                self.configureHideSection(for: .offerListing, dataSource: OfferDO.self)
            }
        }
    }
    
    private func getAllOffers(offersCategoryListResponse: OffersCategoryResponseModel) -> [OfferDO] {
        
        let featuredOffers = offersCategoryListResponse.featuredOffers?.map({ offer in
            var _offer = offer
            _offer.isFeatured = true
            return _offer
        })
        var offers = [OfferDO]()
        if self.offersPage == 1 {
            offers.append(contentsOf: featuredOffers ?? [])
        }
        offers.append(contentsOf: offersCategoryListResponse.offers ?? [])
        return offers
        
    }
    
    fileprivate func configureHideSection<T>(for section: ManCityHomeSectionIdentifier, dataSource: T.Type) {
        if let index = getSectionIndex(for: section) {
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
            
            self.configureDataSource()
        }
    }
    
    func updateOfferWishlistStatus(isFavorite: Bool, offerId: String) {
        offerFavoriteOperation = isFavorite ? 1 : 2
        self.input.send(.updateOfferWishlistStatus(operation: offerFavoriteOperation, offerId: offerId))
    }
    
    fileprivate func configureWishListData(with updateWishlistResponse: WishListResponseModel) {
        var isFavoriteOffer = false
        
        if let favoriteIndexPath = self.selectedIndexPath {
            if let updateWishlistStatus = updateWishlistResponse.updateWishlistStatus, updateWishlistStatus {
                isFavoriteOffer = self.offerFavoriteOperation == 1 ? true : false
            } else {
                isFavoriteOffer = false
            }
            
            (self.dataSource?.dataSources?[favoriteIndexPath.section] as? TableViewDataSource<OfferDO>)?.models?[favoriteIndexPath.row].isWishlisted = isFavoriteOffer
            
            if let cell = contentTableView.cellForRow(at: favoriteIndexPath) as? RestaurantsRevampTableViewCell {
                cell.offerData?.isWishlisted = isFavoriteOffer
                cell.showFavouriteAnimation(isRestaurant: false)
            }
        }
    }
    
    fileprivate func configureBannersData(with offersResponse: GetTopOffersResponseModel) {
        let sectionIdentifier = ManCityHomeSectionIdentifier(rawValue: offersResponse.bannerType ?? "") ?? .inviteFriends
        if let topOffers = offersResponse.ads, !topOffers.isEmpty {
            if let offersIndex = getSectionIndex(for: sectionIdentifier) {
                self.dataSource?.dataSources?[offersIndex] = TableViewDataSource.make(forTopOffers: offersResponse, data: self.manCitySections?.sectionDetails?[offersIndex].backgroundColor ?? "#FFFFFF", completion:{ [weak self] data in
                    self?.delegate?.handleDeepLinkRedirection(redirectionUrl: data.externalWebUrl.asStringOrEmpty())
                })
                configureDataSource()
            }
        } else {
            self.configureHideSection(for: sectionIdentifier, dataSource: GetTopOffersResponseModel.self)
        }
    }
    
}
