//
//  ServiceAssembly.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import Swinject
import CoreData

final class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { r in
            return URLSession(configuration: URLSessionConfiguration.default)
        }.inObjectScope(.container)
        
        container.register(APIServiceProtocol.self) { r in
            return ArcgisAPIService(network: r.resolve(NetworkServiceProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(LocationPermissionHandlerProtocol.self) { r in
            return LocationPermissionHandler()
        }.inObjectScope(.container)

        container.register(LocationServiceProtocol.self) { r in
            return LocationService(permissionHandler: r.resolve(LocationPermissionHandlerProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(NSPersistentContainer.self) { r in
            let container = NSPersistentContainer(name: "Foodzie")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error {
                    fatalError("Unresolved error \(error)")
                }
            })
            return container
        }.inObjectScope(.container)
        
        container.register(Storage<[Place]>.self) { r in
            CoreDataStorageFactory<MOPlace, Place>
                .default(in: r.resolve(NSPersistentContainer.self)!,
                         compactMap: Place.init(with: ),
                         fill: { $0.fill(with: $1) })
        }
        
        container.register(Storage<Location>.self) { r in
            CodableStorageFactory.persistent()
        }
    }
}
