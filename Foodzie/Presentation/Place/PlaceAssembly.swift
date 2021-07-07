//
//  PlaceAssembly.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import Swinject

final class PlaceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(PlaceViewModelProtocol.self) { (r, place: Place) in
            return PlaceViewModel(place: place)
        }
        
        container.register(PlaceViewController.self) { (r, viewModel: PlaceViewModelProtocol) in
            let vc = PlaceViewController.instantiate()
            vc.viewModel = viewModel
            return vc
        }
    }
}
