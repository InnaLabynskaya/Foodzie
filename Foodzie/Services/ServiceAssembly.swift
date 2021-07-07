//
//  ServiceAssembly.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import Swinject

final class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { r in
            return URLSession(configuration: URLSessionConfiguration.default)
        }.inObjectScope(.container)
        container.register(APIServiceProtocol.self) { r in
            return ArcgisAPIService(network: r.resolve(NetworkServiceProtocol.self)!)
        }.inObjectScope(.container)
    }
}
