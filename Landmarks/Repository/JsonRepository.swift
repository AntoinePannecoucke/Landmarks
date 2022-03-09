//
//  JsonRepository.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import Foundation

class JsonRepository {
    
    static public let shared = JsonRepository()
    
    var landmarks : Array<Landmark>
    
    init(){
        landmarks = Array<Landmark>()
        guard let url = Bundle.main.url(forResource: "landmarkData", withExtension: "json") else {
            print("Json file not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            landmarks = try decoder.decode(Array<Landmark>.self, from: data)
        } catch {
            print("Json load error")
        }
    }
    
    func getFeaturedLandmarks() -> Array<Landmark>{
        return landmarks.filter { landmark in
            return landmark.isFeatured == true
        }
    }
    
    func getLandmarksOf(_ category : Category) -> Array<Landmark> {
        return landmarks.filter { landmark in
            return landmark.category == category
        }
    }
    
    func getFavoriteLandmarks() -> Array<Landmark> {
        return landmarks.filter { landmark in
            return landmark.isFavorite == true
        }
    }
}
