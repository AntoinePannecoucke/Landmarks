//
//  SearchCollectionViewCell.swift
//  Landmarks
//
//  Created by lpiem on 16/03/2022.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewListCell {
    @IBOutlet weak var thumbnail : UIImageView!
    @IBOutlet weak var name : UILabel!
    
    func configure(_ landmark: Landmark){
        name.text = landmark.name
        thumbnail.layer.cornerRadius = 10
        thumbnail.image = UIImage(named: landmark.imageName)
    }

}
