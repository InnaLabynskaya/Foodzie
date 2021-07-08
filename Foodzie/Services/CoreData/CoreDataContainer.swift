//
//  CoreDataContainer.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import CoreData

class CoreDataContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }

}
