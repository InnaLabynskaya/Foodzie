//
//  LocationServiceProtocol.swift
//  Foodzie
//
//  Created by Inna Kuts on 08.07.2021.
//

import Foundation
typealias LocationCoordinate = Location
typealias LocationServiceAction = (LocationServiceResult) -> ()

enum LocationServiceError: Error {
    case undefined
    case restricted
    case denied
}

enum LocationServiceResult {
    case success(location: LocationCoordinate)
    case failure(error: LocationServiceError)
}

/// Default location used if real location detection restricted by user. default case contains coordinated of Kyiv city.
enum LocationType {
    case `default`(LocationCoordinate)
    case real(LocationCoordinate)
    
    var coordinates: LocationCoordinate {
        switch self {
        case .default(let location):
            return location
        case .real(let location):
            return location
        }
    }
}

protocol LocationServiceProtocol {
    var lastValidLocation: LocationType { get }
    
    func locationAuthorized() -> Bool
    func startLocationUpdates(_ completion: LocationServiceAction?)
    func stopLocationUpdates()
    func distance(pointA: LocationCoordinate, pointB: LocationCoordinate) -> Double
}
