//
//  MOPlace.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import CoreData

extension MOPlace {
    func populate(with place: Place) {
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
    init(mo: MOPlace) {
        self.init(location: Location(long: mo.longitude, lat: mo.longitude),
                  type: mo.type!,
                  name: mo.placeName!,
                  address: mo.placeAddr!,
                  city: mo.city!,
                  region: mo.region!,
                  country: mo.country!)
    }
}
