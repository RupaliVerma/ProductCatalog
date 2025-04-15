//
//  NetworkService.swift
//  ProductCatalog
//
//  Created by RUPALI VERMA on 15/04/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {

    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(
                        NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    ))
                }
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

        }.resume()
    }
}

