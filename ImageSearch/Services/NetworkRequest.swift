//
//  NetworkRequest.swift
//  ImageSearch
//
//  Created by Nikita Gavrikov on 29.01.2022.
//

import Foundation

class NetworkRequest {
    static let shared = NetworkRequest()

    private init() {}

    func requestData(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
}
