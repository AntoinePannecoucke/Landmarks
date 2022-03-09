//
//  HorizontalBigCellView.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class HorizontalBigCellView : UICollectionViewCell {
    @IBOutlet weak var landmarkName : UILabel!
    @IBOutlet weak var landmarkPhoto : UIImageView!
    
    func configure(_ landmark : Landmark) {
        landmarkName.text = landmark.name
        landmarkPhoto.image = UIImage(named: landmark.imageName)
    }
}
