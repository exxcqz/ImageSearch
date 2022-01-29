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

        URLSession.shared.dataTask(with: request) { data, response, error in
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

    func requestDataString(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
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
