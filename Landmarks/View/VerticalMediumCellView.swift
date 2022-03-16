//
//  VerticalMediumCellView.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import Foundation
import UIKit

class VerticalMediumCellView : UICollectionViewCell {
    @IBOutlet weak var landmarkName : UILabel!
    @IBOutlet weak var landmarkCategory : UILabel!
    @IBOutlet weak var landmarkPhoto : UIImageView!
    
    func configure(_ landmark : Landmark) {
        landmarkName.text = landmark.name
        landmarkCategory.text = landmark.category.rawValue
        landmarkPhoto.layer.cornerRadius = 5
        landmarkPhoto.image = UIImage(named: landmark.imageName)
    }
    
    static func build(_ environment : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection{
        
        switch  (environment.traitCollection.horizontalSizeClass, environment.traitCollection.verticalSizeClass) {
        case (.compact, _):
            return buildCompactCell()
        case (_, _):
            return buildRegularCell()
        }
    }
    
    private static func buildRegularCell() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return section
    }
    
    private static func buildCompactCell() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return section
    }
}
