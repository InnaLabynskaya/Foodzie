//
//  MOPlace.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import CoreData

extension MOPlace {
    func fill(with place: Place) {
        longitude = place.location.long
        latitude = place.location.lat
        type = place.type
        placeName = place.name
        placeAddr = place.address
        city = place.city
        region = place.region
        country = place.country
    }
}

extension Place {
    init?(with mo: MOPlace) {
        guard let type = mo.type,
              let placeName = mo.placeName,
              let placeAddr = mo.placeAddr,
              let city = mo.city,
              let region = mo.region,
              let country = mo.country else {
            return nil
        }
        self.init(location: Location(long: mo.longitude, lat: mo.latitude),
                  type: type,
                  name: placeName,
                  address: placeAddr,
                  city: city,
                  region: region,
                  country: country)
    }
}
