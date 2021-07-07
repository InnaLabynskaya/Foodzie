//
//  MapAssembly.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation
import Swinject

final class MapAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MapViewModelProtocol.self) { (r, router: Router) in
            return MapViewModel(api: r.resolve(APIServiceProtocol.self)!, router: router)
        }
        
        container.register(MapViewController.self) { (r, viewModel: MapViewModelProtocol) in
            let vc = MapViewController.instantiate()
            vc.viewModel = viewModel
            return vc
        }
    }
}
