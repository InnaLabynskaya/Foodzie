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
        container.register(MapViewModelProtocol.self) { r in
            return MapViewModel(api: r.resolve(APIServiceProtocol.self)!)
        }
        
        container.register(MapViewController.self) { r in
            return MapViewController.instantiate()
        }.initCompleted { (r, vc) in
            vc.viewModel = r.resolve(MapViewModelProtocol.self)!
        }
    }
}
