//
//  NetworkService.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    func loadData<T: Codable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

extension URLSession: NetworkServiceProtocol {
    func loadData<T: Codable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(error ?? Errors.unknownNetworkError))
                return
            }
            let decoder = JSONDecoder()
            guard response.statusCode < 400 else {
                completion(.failure(Errors.httpError(code: response.statusCode)))
                return
            }
            do {
                let model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}
