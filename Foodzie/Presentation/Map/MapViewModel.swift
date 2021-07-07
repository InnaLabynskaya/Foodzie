//
//  MapViewModel.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation

protocol MapViewModelProtocol: AnyObject {
    func fetchValues()
    var onPlacesUpdate: Callback<[Place]>? {get set}
}

class MapViewModel: MapViewModelProtocol {
    
    let api: APIServiceProtocol
    var onPlacesUpdate: Callback<[Place]>?
    
    init(api: APIServiceProtocol) {
        self.api = api
    }
    
    func fetchValues() {
        api.fetchSearchPlaces(location: Location(long: 151.20, lat: -33.86),
                              categories: "Food",
                              maxLocations: 20) { [weak self] (result) in
            _ = result.map {self?.onPlacesUpdate?($0)}
        }
    }
    
}
