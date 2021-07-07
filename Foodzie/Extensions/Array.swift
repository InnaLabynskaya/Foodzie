//
//  Array.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
