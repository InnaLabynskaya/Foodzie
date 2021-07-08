//
//  LocationPermissionHandler.swift
//  Foodzie
//
//  Created by Inna Kuts on 08.07.2021.
//

import Foundation
import CoreLocation

class LocationPermissionHandler: LocationPermissionHandlerProtocol {
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    var isLocationEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    var needAccessToLocation: Bool {
        return authorizationStatus == .notDetermined || authorizationStatus == .denied
    }
    
    var isLocationAuthorized: Bool {
        return authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    var isLocationEnabledAndAuthorized: Bool {
        return isLocationEnabled && isLocationAuthorized
    }
    
}
