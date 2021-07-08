//
//  CodableStorageFactory.swift
//  Foodzie
//
//  Created by Inna Kuts on 08.07.2021.
//

import Foundation

struct CodableStorageFactory<Element: Codable> {
    static func persistent(key: String = String(describing: Element.self), userDefaults: UserDefaults = .standard) -> Storage<Element> {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        return Storage(store: { value in
            (try? encoder.encode(value))
                .map { userDefaults.set($0, forKey: key) }
        },
        fetch: {
            return userDefaults.data(forKey: key)
                .flatMap { try? decoder.decode(Element.self, from: $0)}
        },
        clear: {
            userDefaults.removeObject(forKey: key)
        })
    }
}
