//
//  HorizontalSmallCellView.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class HorizontalSmallCellView : UICollectionViewCell {
    @IBOutlet weak var landmarkName : UILabel!
    @IBOutlet weak var landmarkPhoto : UIImageView!
    
    func configure(_ landmark : Landmark) {
        landmarkName.text = landmark.name
        landmarkPhoto.layer.cornerRadius = 5
        landmarkPhoto.image = UIImage(named: landmark.imageName)
    }
}
