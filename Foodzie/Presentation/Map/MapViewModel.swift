//
//  MapViewModel.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation

protocol MapViewModelProtocol {
    var onPlacesUpdate: Callback<[Place]>? {get set}
}

class MapViewModel: MapViewModelProtocol {
    
    let api: APIServiceProtocol
    var onPlacesUpdate: Callback<[Place]>?
    
    init(api: APIServiceProtocol) {
        self.api = api
        api.fetchSearchPlaces(location: Location(long: 0, lat: 0),
                              categories: "Food",
                              maxLocations: 20) { (result) in
            print(result)
        }
    }
    
}
