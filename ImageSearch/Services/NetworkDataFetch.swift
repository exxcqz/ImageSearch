//
//  NetworkDataFetch.swift
//  ImageSearch
//
//  Created by Nikita Gavrikov on 29.01.2022.
//

import Foundation

class NetworkDataFetch {
    static let shared = NetworkDataFetch()

    private init() {}

    func fetchImages(urlString: String, response: @escaping (SearchResult?, Error?) -> Void) {

        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    response(searchResult, nil)
                } catch let jsonError {
                    print("Failed decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error fetch data: \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }
}

