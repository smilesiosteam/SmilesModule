//
//  PageSheetVC.swift
//
//
//  Created by Habib Rehman on 04/03/2024.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager
import SmilesLanguageManager

//MARK: - PageSheetViewController
public class PageSheetViewController: UIViewController {

    //MARK: - Properties
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var leftButton: UIButton!
    var rightButton: UIButton!
    weak var delegate: PageSheetDelegate?
    var pageSheetModel: ConsentConfigDO?
    
    public init(delegate: PageSheetDelegate? = nil, pageSheetModel: ConsentConfigDO? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.pageSheetModel = pageSheetModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let model = pageSheetModel {
            configureUI(with: model)
        }
    }
    
    //MARK: - Button Actions
    @objc func leftButtonTapped() {
        delegate?.didSelectLeftButton()
    }
    
    @objc func rightButtonTapped() {
        delegate?.didSelectRightButton()
    }
}

extension PageSheetViewController {
    //MARK: - UI Configuration
    private func configureUI(with model: ConsentConfigDO) {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.fontTextStyle = .smilesHeadline2
        titleLabel.text = model.title
        
        subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 2
        subtitleLabel.fontTextStyle = .smilesBody2
        subtitleLabel.text = model.description
        
        leftButton = UIButton(type: .custom)
        leftButton.setTitle(model.buttonLeftText, for: .normal)
        leftButton.setTitleColor(.appPurpleColor1, for: .normal)
        leftButton.layer.cornerRadius = 24.0
        leftButton.titleLabel?.fontTextStyle = .smilesHeadline4
        leftButton.backgroundColor = .appButtonDisabledColor
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        
        rightButton = UIButton(type: .custom)
        rightButton.titleLabel?.fontTextStyle = .smilesHeadline4
        rightButton.setTitle(model.buttonRightText, for: .normal)
        rightButton.backgroundColor = .appRevampPurpleMainColor
        rightButton.layer.cornerRadius = 24.0
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .fillEqually
        if ((model.buttonLeftText?.isEmpty) != nil) {
            buttonStackView.addArrangedSubview(leftButton)
        }
        if ((model.buttonRightText?.isEmpty) != nil) {
            buttonStackView.addArrangedSubview(rightButton)
        }
        
        NSLayoutConstraint.activate([
            buttonStackView.heightAnchor.constraint(equalToConstant: 48.0)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        let bezelView = UIView()
        bezelView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        bezelView.layer.cornerRadius = 5.0
        view.addSubview(bezelView)
        bezelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bezelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bezelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0),
            bezelView.widthAnchor.constraint(equalToConstant: 45.0),
            bezelView.heightAnchor.constraint(equalToConstant: 5.0)
            ])
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let dragToDismissGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        bezelView.addGestureRecognizer(dragToDismissGesture)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        
        
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        switch recognizer.state {
        case .changed:
            if translation.y > 0 {
                view.frame.origin.y = translation.y
            }
        case .ended:
            if translation.y > 100 || velocity.y > 500 {
                delegate?.didSelectLeftButton()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = 0
                }
            }
        default:
            break
        }
    }
}
