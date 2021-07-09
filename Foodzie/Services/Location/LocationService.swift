//
//  LocationService.swift
//  Foodzie
//
//  Created by Inna Kuts on 08.07.2021.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let permissionHandler: LocationPermissionHandlerProtocol
    private var locationActionHandler: Callback<Result<LocationCoordinate, LocationServiceError>>?
    private var accessRequested: Bool = false
    private var lastLocation: LocationType = .default(C.kyivLocation)
    
    init(permissionHandler: LocationPermissionHandlerProtocol) {
        self.permissionHandler = permissionHandler
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

// MARK: - Private methods
private extension LocationService {
    struct C {
        static let kyivLocation: LocationCoordinate = LocationCoordinate(long: 30.5238, lat: 50.4547)
    }
    
    func notifyAboutSuccess(withLocation location: CLLocation) {
        if let handler = locationActionHandler {
            let coordinate = location.coordinate
            let locationCoordinate = LocationCoordinate(long: coordinate.longitude, lat: coordinate.latitude)
            let result: Result<LocationCoordinate, LocationServiceError> = .success(locationCoordinate)
            handler(result)
        }
    }
    
    func notifyAboutFailure(withError error: LocationServiceError? = nil) {
        if let handler = locationActionHandler,
            let error = error ?? errorFromAuthorizationStatus() {
            handler(Result.failure(error))
        }
    }
    
    func errorFromAuthorizationStatus() -> LocationServiceError? {
        return permissionHandler.authorizationStatus == .restricted ? .restricted : .denied
    }
}

// MARK: - LocationServiceProtocol
extension LocationService: LocationServiceProtocol {
    
    var lastValidLocation: LocationType {
        return lastLocation
    }
    
    func locationAuthorized() -> Bool {
        return permissionHandler.isLocationAuthorized
    }
    
    func startLocationUpdates(_ completion: Callback<Result<LocationCoordinate, LocationServiceError>>?) {
        locationActionHandler = completion

        if permissionHandler.needAccessToLocation {
            accessRequested = true
            switch permissionHandler.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .denied, .restricted:
                completion?(.failure(.undefined))
            default: break
            }
        } else if permissionHandler.isLocationEnabledAndAuthorized {
            locationManager.startUpdatingLocation()
        } else {
            notifyAboutFailure()
            stopLocationUpdates()
        }
    }

    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationActionHandler = nil
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined || !accessRequested {
            return
        } else if permissionHandler.isLocationEnabledAndAuthorized {
            manager.startUpdatingLocation()
        } else {
            notifyAboutFailure()
            stopLocationUpdates()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last, location.horizontalAccuracy >= 0 else {
            return
        }

        lastLocation = .real(LocationCoordinate(long: location.coordinate.longitude,
                                                lat:  location.coordinate.latitude))
        notifyAboutSuccess(withLocation: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        notifyAboutFailure(withError: .undefined)
        
    }
    
    func distance(pointA: LocationCoordinate, pointB: LocationCoordinate) -> Double {
        return CLLocation(latitude: pointA.lat, longitude: pointA.long)
            .distance(from: CLLocation(latitude: pointB.lat, longitude: pointB.long))
    }
    
}
