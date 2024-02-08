//
//  CollectionsTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/26/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit

public class CollectionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var collectionsData: [CollectionDO]?{
        didSet{
            self.collectionView?.reloadData()
        }
    }
    
    public var callBack: ((CollectionDO) -> ())?
    public static let module = Bundle.module
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: String(describing: CollectionsCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: CollectionsCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setupCollectionViewLayout()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(112), heightDimension: .absolute(176)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets.leading = 16
            return section
        }
        
        return layout
    }
    
    public func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
}

extension CollectionsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsData?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let data = collectionsData?[indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionsCollectionViewCell", for: indexPath) as? CollectionsCollectionViewCell else {return UICollectionViewCell()}
            
            cell.configureCell(with: data)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = collectionsData?[indexPath.row] {
            callBack?(data)
        }
    }
}
