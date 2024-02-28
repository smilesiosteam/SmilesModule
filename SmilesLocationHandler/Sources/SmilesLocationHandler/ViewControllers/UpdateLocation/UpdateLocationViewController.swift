//
//  SmilesManageAddressesViewController.swift
//
//
//  Created by Ghullam  Abbas on 17/11/2023.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager
import Combine
import SmilesLoader
import CoreLocation

final class UpdateLocationViewController: UIViewController, Toastable, SmilesPresentableMessage {
    
    // MARK: - IBOutlets
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var savedAddressedLabel: UILabel!
    @IBOutlet weak var addNewAddressLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentLocationContainer: UIView!
    @IBOutlet weak var confirmLocationButton: UIButton!
    
    // MARK: - Properties
    private var isEditingEnabled: Bool = false
    private var addressDataSource = [Address]()
    private var selectedAddress: Address?
    private var isCurrentLocationSetByUser = false
    private var input: PassthroughSubject<ManageAddressViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: ManageAddressViewModel = {
        return ManageAddressViewModel()
    }()
    private var getAllAddresses = true
    private var userCurrentLocation: CLLocation?
    private weak var delegate: UpdateUserLocationDelegate?
    private var isFromFoodCart: Bool
    private var updateFoodCart = false
    private var showShimmer = false
    
    // MARK: - Methods
    init(delegate: UpdateUserLocationDelegate? = nil, isFromFoodCart: Bool) {
        self.delegate = delegate
        self.isFromFoodCart = isFromFoodCart
        super.init(nibName: "UpdateLocationViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        
        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = "UpdateYourLocationText".localizedString
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        
        locationNavBarTitle.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        
        self.navigationItem.titleView = locationNavBarTitle
        /// Back Button Show
        let backButton: UIButton = UIButton(type: .custom)
        // btnBack.backgroundColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
        let image = UIImage(named: "back_circle", in: .module, compatibleWith: nil)
        
        
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        backButton.layer.cornerRadius = backButton.frame.height / 2
        backButton.clipsToBounds = true
        
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func styleFontAndTextColor() {
        
        self.savedAddressedLabel.fontTextStyle = .smilesHeadline3
        self.confirmLocationButton.fontTextStyle = .smilesHeadline4
        self.editButton.fontTextStyle = .smilesHeadline4
        self.addNewAddressLabel.fontTextStyle = .smilesHeadline4
        self.currentLocationLabel.fontTextStyle = .smilesBody3
        self.savedAddressedLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        
    }
    
    private func updateUI() {
        self.editButton.isHidden = true
        self.confirmLocationButton.setTitle("confirm_address".localizedString, for: .normal)
        self.addNewAddressLabel.text = "add_new_address".localizedString
        self.savedAddressedLabel.text = "SavedAddresses".localizedString
        self.editButton.setTitle("Manage".localizedString, for: .normal)
        setupConfirmButton()
        LocationManager.shared.isLocationEnabled(completion: { [weak self] isEnabled in
            guard let self else { return }
            if isEnabled && !self.isCurrentLocationSetByUser {
                LocationManager.shared.getLocation { [weak self] location, error in
                    guard let self, let location else { return }
                    self.userCurrentLocation = location
                    self.input.send(.reverseGeocodeLatitudeAndLongitudeForAddress(location: location))
                }
            } else {
                self.currentLocationLabel.text = ""
                self.currentLocationContainer.isHidden = true
            }
        })
        
    }
    
    func setupTableViewCells() {
        addressesTableView.registerCellFromNib(AddressDetailsTableViewCell.self, withIdentifier: String(describing: AddressDetailsTableViewCell.self), bundle: .module)
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
        if isFromFoodCart && updateFoodCart {
            delegate?.userLocationUpdatedSuccessfully()
        }
    }
    
    private func getAddresses() {
        
        if let addresses = GetAllAddressesResponse.fromModuleFile()?.addresses {
            showShimmer = true
            setupAddressesData(addresses: addresses)
        }
        self.input.send(.getAllAddress)
        
    }
    
    private func setupConfirmButton() {
        
        let isAddressSelected = selectedAddress != nil
        self.confirmLocationButton.isUserInteractionEnabled = isAddressSelected
        self.confirmLocationButton.backgroundColor = isAddressSelected ? .appRevampPurpleMainColor : .black.withAlphaComponent(0.1)
        self.confirmLocationButton.setTitleColor(isAddressSelected ? .white : .black.withAlphaComponent(0.5), for: .normal)
        
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        setupTableViewCells()
        styleFontAndTextColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        updateUI()
        if getAllAddresses {
            getAddresses()
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTabEditButton(_ sender: UIButton) {
        if let navigationController {
            SmilesLocationRouter.shared.pushManageAddressesViewController(with: navigationController, updateLocationDelegate: self)
        }
    }
    
    @IBAction func didTabSearchButton(_ sender: UIButton) {
        SmilesLocationRouter.shared.pushSearchLocationVC(isFromFoodCart: isFromFoodCart, locationSelected: { [weak self] selectedLocation in
            self?.getAllAddresses = false
            // Added delay so that Add address screen poped completely and this controller become visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                SmilesLoader.show()
                self?.input.send(.getUserLocation(location: CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)))
            }
        })
    }
    
    @IBAction func didTabAddAddressButton(_ sender: UIButton) {
        let city = GetCitiesModel()
        city.cityLatitude = userCurrentLocation?.coordinate.latitude
        city.cityLongitude = userCurrentLocation?.coordinate.longitude
        SmilesLocationRouter.shared.pushConfirmUserLocationVC(selectedCity: city, delegate: self)
    }
    
    @IBAction func didTabCurrentLocationButton(_ sender: UIButton) {
        
        self.isEditingEnabled = false
        addressDataSource.forEach { address in
            address.selection = 0
        }
        selectedAddress = nil
        self.addressesTableView.reloadData()
        
        let city = GetCitiesModel()
        city.cityLatitude = userCurrentLocation?.coordinate.latitude
        city.cityLongitude = userCurrentLocation?.coordinate.longitude
        SmilesLocationRouter.shared.pushConfirmUserLocationVC(selectedCity: city, sourceScreen: .updateUserLocation(isFromFoodCart: isFromFoodCart), delegate: self)
        
    }
    
    @IBAction func didTabConfirmLocation(_ sender: UIButton) {
        
        if let address = selectedAddress {
            address.selection = 1
            SmilesLoader.show()
            self.input.send(.saveAddress(address: address))
        }
        
    }
    
}


// MARK: - UITableView Delegate & DataSource -
extension UpdateLocationViewController: UITableViewDelegate, UITableViewDataSource, AddressDetailsTbaleViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressDetailsTableViewCell", for: indexPath) as? AddressDetailsTableViewCell else { return UITableViewCell() }
        let address = addressDataSource[indexPath.row]
        var isSelected: Bool?
        if let selectedAddress {
            isSelected = selectedAddress.addressId == address.addressId
        }
        cell.delegate = showShimmer ? nil : self
        if showShimmer {
            DispatchQueue.main.async {
                cell.enableSkeleton()
                cell.showAnimatedSkeleton()
                cell.configureCell(with: address, isFromManageAddress: false, isEditingEnabled: self.isEditingEnabled, isSelected: isSelected)
            }
        } else {
            cell.hideSkeleton()
            cell.configureCell(with: address, isFromManageAddress: false, isEditingEnabled: self.isEditingEnabled, isSelected: isSelected)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func didTapDetailButtonInCell(_ cell: AddressDetailsTableViewCell) {
        // if editing mode is enabled then it will not let user select
        if !isEditingEnabled{
            if let indexPath = self.addressesTableView.indexPath(for: cell) {
                self.selectedAddress = self.addressDataSource[indexPath.row]
                setupConfirmButton()
                self.addressesTableView.reloadData()
            }
        }
    }
    
}
// MARK: - ViewModel Binding
extension UpdateLocationViewController {
    
    func bind(to viewModel: ManageAddressViewModel) {
        input = PassthroughSubject<ManageAddressViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .fetchAllAddressDidSucceed(let response):
                    self.handleAddressListResponse(response: response)
                case .fetchAllAddressDidFail(error: let error):
                    if let errorMsg = error?.localizedDescription, !errorMsg.isEmpty {
                        self.showMessage(model: SmilesMessageModel(description: errorMsg, showForRetry: true), delegate: self)
                    }
                case .getUserLocationDidSucceed(response: let response, location: _):
                    self.handleUserLocationResponse(response: response)
                case .getUserLocationDidFail(let error):
                    SmilesLoader.dismiss()
                    if !error.localizedDescription.isEmpty {
                        self.showMessage(model: SmilesMessageModel(description: error.localizedDescription))
                    }
                case .saveAddressDidSucceed(let response):
                    SmilesLoader.dismiss()
                    self.handleSaveAddressResponse(response: response)
                case .saveAddressDidFail(error: let error):
                    SmilesLoader.dismiss()
                    if let errorMsg = error?.localizedDescription, !errorMsg.isEmpty {
                        self.showMessage(model: SmilesMessageModel(description: errorMsg))
                    }
                case .fetchAddressFromCoordinatesDidSucceed(let address):
                    self.currentLocationLabel.text = address
                    self.currentLocationContainer.isHidden = false
                case .fetchAddressFromCoordinatesDidFail(_):
                    self.currentLocationLabel.text = ""
                    self.currentLocationContainer.isHidden = true
                case .updateUserLocationDidSucceed(response: let response):
                    self.handleUpdateLocationOnMamba(response: response)
                case .updateUserLocationDidFail(error: let error):
                    SmilesLoader.dismiss()
                    if !error.localizedDescription.isEmpty {
                        self.showMessage(model: SmilesMessageModel(description: error.localizedDescription))
                    }
                default: break
                }
            }.store(in: &cancellables)
    }
}

// MARK: - RESPONSE HANDLING -
extension UpdateLocationViewController {
    
    private func handleAddressListResponse(response: GetAllAddressesResponse) {
        
        if let errorMessage = response.responseMsg, !errorMessage.isEmpty {
        self.showMessage(model: SmilesMessageModel(title: response.errorTitle, description: errorMessage, showForRetry: true), delegate: self)
        } else {
            showShimmer = false
            setupAddressesData(addresses: response.addresses ?? [])
        }
        
    }
    
    private func setupAddressesData(addresses: [Address]) {
        
        self.editButton.isHidden = addresses.isEmpty
        self.savedAddressedLabel.isHidden = addresses.isEmpty
        self.addressDataSource = addresses
        self.addressesTableView.reloadData()
        
    }
    
    private func handleUserLocationResponse(response: RegisterLocationResponse) {
        
        if let errorMessage = response.responseMsg, !errorMessage.isEmpty {
            SmilesLoader.dismiss()
            self.showMessage(model: SmilesMessageModel(title: response.errorTitle, description: errorMessage))
        } else if let userInfo = response.userInfo {
            LocationStateSaver.saveLocationInfo(userInfo, isFromMamba: false)
            guard let latitudeString = userInfo.latitude, let latitude = Double(latitudeString),
                  let longitudeString = userInfo.longitude, let longitude = Double(longitudeString) else { return }
            self.input.send(.updateLocationToMamba(location: CLLocation(latitude: latitude, longitude: longitude)))
        }
        
    }
    
    private func handleUpdateLocationOnMamba(response: RegisterLocationResponse) {
        
        SmilesLoader.dismiss()
        if let errorMessage = response.responseMsg, !errorMessage.isEmpty {
            self.showMessage(model: SmilesMessageModel(title: response.errorTitle, description: errorMessage))
        } else if let userInfo = response.userInfo {
            LocationStateSaver.saveLocationInfo(userInfo, isFromMamba: true)
            if !updateFoodCart {
                SmilesLocationRouter.shared.popVC()
                self.delegate?.userLocationUpdatedSuccessfully()
            }
        }
        
    }
    
    private func handleSaveAddressResponse(response: SaveAddressResponseModel) {
        
        if let errorMessage = response.responseMsg, !errorMessage.isEmpty {
            self.showMessage(model: SmilesMessageModel(title: response.errorTitle, description: errorMessage))
        } else if let latitudeString = self.selectedAddress?.latitude, let longitudeString = self.selectedAddress?.longitude,
           let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
            SmilesLoader.show()
            self.input.send(.getUserLocation(location: CLLocation(latitude: latitude, longitude: longitude)))
        }
        
    }
    
}

// MARK: - CONFIRM LOCATION DELEGATE -
extension UpdateLocationViewController: ConfirmLocationDelegate {
    
    func newAddressAdded(location: CLLocation) {
        getAllAddresses = false
        SmilesLoader.show()
        self.input.send(.getUserLocation(location: location))
    }
    
    func locationPicked(location: SearchLocationResponseModel) {
        guard let latitude = location.lat, let longitude = location.long else { return }
        getAllAddresses = false
        isCurrentLocationSetByUser = true
        SmilesLoader.show()
        self.input.send(.getUserLocation(location: CLLocation(latitude: latitude, longitude: longitude)))
    }
    
}

// MARK: - SMILES ERROR VIEW DELEGATE -
extension UpdateLocationViewController: SmilesMessageViewDelegate {
    
    func primaryButtonPressed(isForRetry: Bool) {
        if isForRetry {
            getAddresses()
        }
    }
    
}

// MARK: - UPDATE USER LOCATION DELEGATE -
extension UpdateLocationViewController: UpdateUserLocationDelegate {
    
    func userLocationUpdatedSuccessfully() {
        if let controllers = navigationController?.viewControllers,
           let index = controllers.firstIndex(where: { $0 is UpdateLocationViewController }) {
            navigationController?.popToViewController(controllers[index - 1], animated: true)
            delegate?.userLocationUpdatedSuccessfully()
        }
    }
    
    func defaultAddressDeleted() {
        updateFoodCart = true
        guard let userInfo = LocationStateSaver.getLocationInfo(),
              let latitudeString = userInfo.latitude, let latitude = Double(latitudeString),
              let longitudeString = userInfo.longitude, let longitude = Double(longitudeString) else { return }
        self.input.send(.updateLocationToMamba(location: CLLocation(latitude: latitude, longitude: longitude)))
    }
    
}
