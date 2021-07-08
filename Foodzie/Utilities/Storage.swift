//
//  Storage.swift
//  Foodzie
//
//  Created by Inna Kuts on 08.07.2021.
//

import Foundation

protocol StorageProtocol {
    associatedtype Element
    var store: (_ data: Element) -> Void { get }
    var fetch: () -> Element? { get }
    var clear: () -> Void { get }
}

struct Storage<Element>: StorageProtocol {
    let store: (Element) -> Void
    let fetch: () -> Element?
    let clear: () -> Void
}

extension Storage {

    init<S: StorageProtocol>(_ storage: S) where S.Element == Element {
        self.store = storage.store
        self.fetch = storage.fetch
        self.clear = storage.clear
    }
}

extension StorageProtocol {
    func map<T>(wrap: @escaping (Element) -> T,
                unwrap: @escaping (T) -> Element) -> Storage<T> {
        return Storage(store: { [store] element in
            store(unwrap(element))
        },
        fetch: { [fetch] in
            return fetch().map(wrap)
        },
        clear: clear)
    }
}

