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
}
