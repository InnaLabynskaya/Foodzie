//
//  MapViewModel.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation

protocol MapViewModelInputProtocol: AnyObject {
    func update(location: Location)
    func select(place: Place)
    func showList()
}

protocol MapViewModelOutputProtocol: AnyObject {
    var deviceLocation: Location {get}
    var onPlacesUpdate: Callback<[Place]>? {get set}
    var onDeviceLocationUpdate: Callback<Location>? {get set}
}

class MapViewModel: MapViewModelOutputProtocol, MapViewModelInputProtocol {
    
    private let api: APIServiceProtocol
    private let router: Router
    private let locationService: LocationServiceProtocol
    private let storage: Storage<[Place]>
    private let lastLocationStorage: Storage<Location>
    
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
         lastLocationStorage: Storage<Location>,
         router: Router) {
        self.api = api
        self.router = router
        self.locationService = locationService
        self.storage = storage
        self.lastLocationStorage = lastLocationStorage
        self.deviceLocation = lastLocationStorage.fetch() ?? locationService.lastValidLocation.coordinates
        setup()
    }
    
    private func placeIsNearEnough(place: Place) -> Bool {
        return locationService.distance(pointA: place.location, pointB: deviceLocation) < MapViewModel.NearEnough
    }
    
    private func setup() {
        if let stored = storage.fetch(), stored.allSatisfy(self.placeIsNearEnough) {
            places = stored
        } else {
            update(location: deviceLocation)
        }
        locationService.startLocationUpdates { [weak self] (result) in
            guard case .success(location: let location) = result else {
                return
            }
            self?.deviceLocation = location
            self?.locationService.stopLocationUpdates()
        }
    }
    
    func update(location: Location) {
        lastLocationStorage.store(location)
        request = api.fetchSearchPlaces(location: location) { [weak self] (result) in
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
