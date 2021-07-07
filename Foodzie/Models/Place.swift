//
//  Place.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation

struct Location: Codable {
    var long: Double
    var lat: Double
}

struct Place: Codable {
    var location: Location
    var type: String
    var placeName: String
    var placeAddr: String
    var city: String
    var region: String
    var country: String
}

