//
//  HeaderCollectionReusableView.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class HeaderCollectionReusableView : UICollectionReusableView {
    @IBOutlet weak var title : UILabel!
    
    func configure(_ section : ViewController.Section?){
        guard let section = section else {
            title.text = ""
            return
        }

        title.text = section.rawValue
    }
}
