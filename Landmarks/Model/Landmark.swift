//
//  Landmark.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import Foundation
import MapKit

struct Landmark : Decodable, Hashable {
    struct Coordinates : Decodable, Hashable {
        var latitude : Double
        var longitude : Double
    }

    
    static func == (lhs: Landmark, rhs: Landmark) -> Bool {
        return lhs.id == rhs.id
    }
    
    var name : String
    var category : Category
    var state : String
    var id : Int
    var isFeatured : Bool
    var isFavorite : Bool
    var park : String
    private let coordinates : Coordinates
    var description : String
    var imageName : String
    
    var locationCoordinates: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}

enum Category : String, Decodable, Hashable {
    case rivers = "Rivers"
    case lakes = "Lakes"
    case montains = "Mountains"
}
