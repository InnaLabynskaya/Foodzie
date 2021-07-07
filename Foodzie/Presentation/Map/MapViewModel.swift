//
//  MapViewModel.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation

protocol MapViewModelProtocol: AnyObject {
    func update(location: Location)
    func select(place: Place)
    func showList()
    var onPlacesUpdate: Callback<[Place]>? {get set}
}

class MapViewModel: MapViewModelProtocol {
    
    let api: APIServiceProtocol
    let router: Router
    private var request: Cancelable? {
        willSet {
            request?.cancel()
        }
    }
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
    
    init(api: APIServiceProtocol, router: Router) {
        self.api = api
        self.router = router
        update(location: Location(long: 151.20, lat: -33.86))
    }
    
    func update(location: Location) {
        request = api.fetchSearchPlaces(location: location,
                              categories: "Food",
                              maxLocations: 20) { [weak self] (result) in
            _ = result.map {self?.places = $0}
        }
    }
    
    func select(place: Place) {
        router.navigateTo(place: place)
    }
    func showList() {
        router.navigateTo(list: places)
    }
}
