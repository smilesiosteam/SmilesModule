//
//  TopOffersTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 27/07/2023.
//

import UIKit
import SmilesUtilities
import SmilesPageController

public class TopOffersTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: JXPageControlJump!
    @IBOutlet weak var pageControlHeight: NSLayoutConstraint!
    
    private var autoScroller: CollectionViewAutoScroller?
    public var sliderTimeInterval: Double?
    public var collectionsData: [Any]? {
        didSet{
            collectionView?.reloadData()
            if showPageControl {
                autoScroller?.resetAutoScroller()
                pageController.currentIndex = 0
                pageController.activeColor = .appRevampPurpleMainColor
                autoScroller?.itemsCount = collectionsData?.count ?? 0
                autoScroller?.startTimer(interval: getTimeInterval())
            }
        }
    }
    public static let module = Bundle.module
    public var callBack: ((GetTopOffersResponseModel.TopOfferAdsDO) -> ())?
    public var topAdsCallBack: ((GetTopAdsResponseModel.TopAdsDto.TopAd) -> ())?
    public var showPageControl = true {
        didSet {
            if !showPageControl {
                pageController.isHidden = true
                pageControlHeight.constant = 0
                autoScroller = nil
                layoutIfNeeded()
            }
        }
    }
    weak var timer: Timer?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: String(describing: TopOffersCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: TopOffersCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setupCollectionViewLayout()
        if showPageControl {
            autoScroller = CollectionViewAutoScroller(collectionView: collectionView, itemsCount: 0, currentIndex: 0)
        }
        pageController.isHidden = !showPageControl
        if AppCommonMethods.languageIsArabic() {
            pageController.transform = CGAffineTransform(rotationAngle: .pi)
        }
        pageController.contentAlignment = JXPageControlAlignment(.left,.center)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(138)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            
            section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
                guard let self = self, self.showPageControl else { return }
                let page = round(offset.x / self.collectionView.bounds.width)
                self.pageController.currentPage = Int(page)
                self.autoScroller?.currentIndex = Int(page)
            }
            return section
        }
        
        return layout
    }
    
    public func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
    
    private func getTimeInterval() -> Double {
        var interval: Double = 5.0
        if let timeInterval = sliderTimeInterval {
            interval = timeInterval
        }
        return interval
    }
    
}

extension TopOffersTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = collectionsData?.count ?? 0
        
        pageController.numberOfPages = count
        if showPageControl {
            pageController.isHidden = !(count > 1)
        }
        
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopOffersCollectionViewCell", for: indexPath) as? TopOffersCollectionViewCell else {return UICollectionViewCell()}
        
        if let data = collectionsData?[safe: indexPath.row] as? GetTopOffersResponseModel.TopOfferAdsDO {
            cell.configureCell(with: data.adImageUrl ?? "", animationURL: data.adsJsonAnimationUrl)
            return cell
        } else if let data = collectionsData?[safe: indexPath.row] as? GetTopAdsResponseModel.TopAdsDto.TopAd {
            cell.configureCell(with: data.adImageUrl ?? "", animationURL: data.adsJsonAnimationUrl)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = collectionsData?[safe: indexPath.row] as? GetTopOffersResponseModel.TopOfferAdsDO {
            callBack?(data)
        } else if let data = collectionsData?[safe: indexPath.row] as? GetTopAdsResponseModel.TopAdsDto.TopAd {
            topAdsCallBack?(data)
        }
    }
}

extension TopOffersTableViewCell {
    // -------------------------------------------------------------------------------
    //    Timer Controls
    // -------------------------------------------------------------------------------
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: getTimeInterval(), target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = collectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if let row = indexPath?.row, let section = indexPath?.section {
                    if (row  <= (collectionsData?.count ?? 0) - 1) {
                        let indexPath1: IndexPath?
                        indexPath1 = IndexPath(row: row + 1, section: section)
                        pageController.currentPage = row
                        coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    } else {
                        let indexPath1: IndexPath?
                        indexPath1 = IndexPath(row: 1, section: section)
                        pageController.currentPage = 0
                        coll.scrollToItem(at: indexPath1!, at: .right, animated: false)
                    }
                }
            }
        }
    }
}
