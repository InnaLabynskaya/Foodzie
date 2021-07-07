//
//  PlaceViewModel.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation

protocol PlaceViewModelProtocol: AnyObject {
    var onPlaceUpdate: Callback<Place>? {get set}
}

class PlaceViewModel: PlaceViewModelProtocol {
    
    let place: Place
    var onPlaceUpdate: Callback<Place>? {
        didSet {
            onPlaceUpdate?(place)
        }
    }
    
    init(place: Place) {
        self.place = place
    }
}
