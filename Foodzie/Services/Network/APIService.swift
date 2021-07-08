//
//  APIService.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import CoreLocation

protocol APIServiceProtocol {
    func fetchSearchPlaces(location: Location,
                           categories: String,
                           maxLocations: Int,
                           completion: @escaping (Result<[Place], Error>) -> Void) -> Cancelable
}

class ArcgisAPIService: APIServiceProtocol {
    let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    let root = URL(string: "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/")!

    func fetchSearchPlaces(location: Location,
                           categories: String,
                           maxLocations: Int,
                           completion: @escaping (Result<[Place], Error>) -> Void) -> Cancelable {
        var components = URLComponents(url: root.appendingPathComponent("findAddressCandidates"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "f", value: "json"),
            URLQueryItem(name: "category", value: categories),
            URLQueryItem(name: "maxLocations", value: "\(maxLocations)"),
            URLQueryItem(name: "outFields", value: "PlaceName,Type,Place_Addr,City,Region,Country"),
            URLQueryItem(name: "location", value: "\(location.long),\(location.lat)"),
        ]
        
        guard let request = components?.url.map({ URLRequest(url:$0) }) else {
            completion(.failure(Errors.badRequest))
            return EmptyCancelable()
        }
        return network.loadData(with: request, completion: { (result: Result<SearchPlaceResponse, Error>) in
            let response = result.map { response in response.candidates.map(Place.init(response:)) }
            DispatchQueue.main.async {
                completion(response)
            }
        })
    }
}

struct EmptyCancelable: Cancelable {
    func cancel() {}
}

private struct SearchPlaceResponse: Codable {
    var candidates: [PlaceResponse]
}

private struct Point: Codable {
    var x: Double
    var y: Double
}

private struct PlaceResponse: Codable {
    var location: Point
    var attributes: Attributes
}

private struct Attributes: Codable {
    var type: String
    var placeName: String
    var placeAddr: String
    var city: String
    var region: String
    var country: String
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case placeName = "PlaceName"
        case placeAddr = "Place_Addr"
        case city = "City"
        case region = "Region"
        case country = "Country"
    }
}

private extension Place {
    init(response: PlaceResponse) {
        self.init(location: Location(long: response.location.x, lat: response.location.y),
                  type: response.attributes.type,
                  name: response.attributes.placeName,
                  address: response.attributes.placeAddr,
                  city: response.attributes.city,
                  region: response.attributes.region,
                  country: response.attributes.country)
    }
}
