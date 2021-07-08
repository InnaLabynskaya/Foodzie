//
//  CoreDataStorageFactory.swift
//  Foodzie
//
//  Created by Inna Kuts on 08.07.2021.
//

import Foundation
import CoreData

struct CoreDataStorageFactory<ManagedObject: NSManagedObject, Element> {
    static func `default`(in container: NSPersistentContainer,
                          compactMap transform: @escaping (ManagedObject) -> Element?,
                          fill: @escaping (ManagedObject, Element) -> Void) -> Storage<[Element]> {
        return Storage { (elements) in
            container.performBackgroundTask { (context) in
                do {
                    try context.fetch(ManagedObject.fetchRequest())
                        .compactMap {$0 as? ManagedObject}
                        .forEach(context.delete(_:))
                    elements.forEach {
                        let mo = ManagedObject(context: context)
                        fill(mo, $0)
                    }
                    try context.save()
                } catch {}
            }
        } fetch: { () -> [Element]? in
            try? container.viewContext.fetch(ManagedObject.fetchRequest())
                .compactMap {$0 as? ManagedObject}
                .compactMap(transform)
        } clear: {
            container.performBackgroundTask { (context) in
                do {
                    try context.fetch(ManagedObject.fetchRequest())
                        .compactMap {$0 as? ManagedObject}
                        .forEach(context.delete(_:))
                    try context.save()
                } catch {}
            }
        }
    }
}

