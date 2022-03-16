//
//  DetailsViewController.swift
//  Landmarks
//
//  Created by lpiem on 16/03/2022.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var park: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var landmark : Landmark?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let landmark = landmark else {
            dismiss(animated: true)
            return
        }
        
        title = landmark.name

        mapView.region = MKCoordinateRegion(center: landmark.locationCoordinates, latitudinalMeters: 10 * 1000, longitudinalMeters: 10 * 1000)
        mapView.isUserInteractionEnabled = false
        
        image.layer.cornerRadius = 150/2
        image.image = UIImage(named: landmark.imageName)
        
        park.text = landmark.park
        address.text = landmark.state
        desc.text = landmark.description
        
    }

}
