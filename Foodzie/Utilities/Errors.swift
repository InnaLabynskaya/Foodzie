//
//  Errors.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation

enum Errors: Error {
    case unknownNetworkError
    case httpError(code: Int)
    case badRequest
}
