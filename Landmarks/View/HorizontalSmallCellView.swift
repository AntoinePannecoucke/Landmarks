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
        self.landmarkName.text = landmark.name
        self.landmarkPhoto.layer.cornerRadius = 5
        self.landmarkPhoto.image = UIImage(named: landmark.imageName)
    }
}
