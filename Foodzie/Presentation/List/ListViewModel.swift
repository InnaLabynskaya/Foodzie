//
//  ListViewModel.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation

protocol ListViewModelProtocol: AnyObject {
    func select(place: Place)
    var onPlacesUpdate: Callback<[Place]>? {get set}
}

class ListViewModel: ListViewModelProtocol {
    
    let places: [Place]
    let router: Router
    var onPlacesUpdate: Callback<[Place]>? {
        didSet {
            onPlacesUpdate?(places)
        }
    }
    
    init(places: [Place], router: Router) {
        self.places = places
        self.router = router
    }

    func select(place: Place) {
        router.navigateTo(place: place)
    }

}
