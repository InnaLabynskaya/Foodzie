//
//  LocationPermissionHandlerProtocol.swift
//  Foodzie
//
//  Created by Inna Kuts on 08.07.2021.
//

import Foundation
import CoreLocation

protocol LocationPermissionHandlerProtocol {
    
    var authorizationStatus: CLAuthorizationStatus { get }
    var isLocationEnabled: Bool { get }
    var needAccessToLocation: Bool { get }
    var isLocationAuthorized: Bool { get }
    var isLocationEnabledAndAuthorized: Bool { get }
        
}
