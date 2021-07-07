//
//  MapViewModel.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation

protocol MapViewModelProtocol: AnyObject {
    var onPlacesUpdate: Callback<[Place]>? {get set}
}

class MapViewModel: MapViewModelProtocol {
    
    let api: APIServiceProtocol
    var places: [Place] = [] {
        didSet {
            onPlacesUpdate?(places)
        }
    }
    var onPlacesUpdate: Callback<[Place]>? {
        didSet {
            onPlacesUpdate?(places)
        }
    }
    
    init(api: APIServiceProtocol) {
        self.api = api
        api.fetchSearchPlaces(location: Location(long: 151.20, lat: -33.86),
                              categories: "Food",
                              maxLocations: 20) { [weak self] (result) in
            _ = result.map {self?.places = $0}
        }
    }
    
}
