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
    var deviceLocation: Location {get}
    var onPlacesUpdate: Callback<[Place]>? {get set}
    var onDeviceLocationUpdate: Callback<Location>? {get set}
}

class MapViewModel: MapViewModelProtocol {
    
    private let api: APIServiceProtocol
    private let router: Router
    private let locationService: LocationServiceProtocol
    private let storage: Storage<[Place]>
    
    static let NearEnough: Double = 2_000//2 km
    
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
    var deviceLocation: Location {
        didSet {
            onDeviceLocationUpdate?(deviceLocation)
        }
    }
    var onDeviceLocationUpdate: Callback<Location>? {
        didSet {
            onDeviceLocationUpdate?(deviceLocation)
        }
    }
    
    init(api: APIServiceProtocol,
         locationService: LocationServiceProtocol,
         storage: Storage<[Place]>,
         router: Router) {
        self.api = api
        self.router = router
        self.locationService = locationService
        self.storage = storage
        self.deviceLocation = locationService.lastValidLocation.coordinates
        setup()
    }
    
    private func placeIsNearEnough(place: Place) -> Bool {
        return locationService.distance(pointA: place.location, pointB: deviceLocation) < MapViewModel.NearEnough
    }
    
    private func setup() {
        guard let stored = storage.fetch(),
              stored.allSatisfy(self.placeIsNearEnough) else {
            update(location: deviceLocation)
            return
        }
        self.places = stored
    }
    
    func update(location: Location) {
        request = api.fetchSearchPlaces(location: location,
                              categories: "Food",
                              maxLocations: 20) { [weak self] (result) in
            guard case .success(let places) = result, let self = self else {
                return
            }
            self.storage.store(places)
            self.places = places
        }
    }
    
    func select(place: Place) {
        router.navigateTo(place: place)
    }
    func showList() {
        router.navigateTo(list: places)
    }
}
