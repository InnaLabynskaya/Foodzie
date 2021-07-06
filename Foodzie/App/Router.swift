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
    let window: UIWindow
    let resolver: Resolver
    
    init(window: UIWindow, resolver: Resolver) {
        self.window = window
        self.resolver = resolver
    }
    
    func start() {
        window.rootViewController = resolver.resolve(MapViewController.self)!
        window.makeKeyAndVisible()
    }
    
}
