//
//  ListAssembly.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation

import Swinject

final class ListAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(ListViewModelProtocol.self) { (r, places: [Place], router: Router) in
            return ListViewModel(places: places, router: router)
        }
        
        container.register(ListViewController.self) { (r, viewModel: ListViewModelProtocol) in
            let vc = ListViewController.instantiate()
            vc.viewModel = viewModel
            return vc
        }
    }
}
