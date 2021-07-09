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
        container.register(MapViewModel.self) { (r, router: Router) in
            return MapViewModel(api: r.resolve(APIServiceProtocol.self)!,
                                locationService: r.resolve(LocationServiceProtocol.self)!,
                                storage: r.resolve(Storage<[Place]>.self)!,
                                lastLocationStorage: r.resolve(Storage<Location>.self)!,
                                router: router)
        }
        
        container.register(MapViewController.self) { (r, viewModel: MapViewModel) in
            let vc = MapViewController.instantiate()
            vc.viewModelInput = viewModel
            vc.viewModelOutput = viewModel
            return vc
        }
    }
}
