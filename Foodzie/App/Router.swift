//
//  Router.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation
import Swinject
import UIKit

class Router {
    private let window: UIWindow
    private let resolver: Resolver
    
    init(window: UIWindow, resolver: Resolver) {
        self.window = window
        self.resolver = resolver
    }
    
    func navigateToRoot() {
        guard let root = window.rootViewController else {
            resetStack()
            return
        }
        root.dismiss(animated: true, completion: nil)
    }
    
    private func resetStack() {
        let viewModel = resolver.resolve(MapViewModelProtocol.self, argument: self)!
        let viewController = resolver.resolve(MapViewController.self, argument: viewModel)!
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func navigateTo(place: Place) {
        let viewModel = resolver.resolve(PlaceViewModelProtocol.self, argument: place)!
        let viewController = resolver.resolve(PlaceViewController.self, argument: viewModel)!
        window.topMostViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func navigateTo(list places: [Place]) {
        let viewModel = resolver.resolve(ListViewModelProtocol.self, arguments: places, self)!
        let viewController = resolver.resolve(ListViewController.self, argument: viewModel)!
        window.topMostViewController?.present(viewController, animated: true, completion: nil)
    }
    
}
