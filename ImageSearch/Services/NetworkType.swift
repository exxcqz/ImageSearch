//
//  NetworkType.swift
//  ImageSearch
//
//  Created by Nikita Gavrikov on 29.01.2022.
//

import Foundation

enum NetworkType {

    case getSearchImage

    var baseURL: URL {
        return URL(string: "https://api.unsplash.com/")!
    }

    var headers: [String: String] {
        return ["Authorization": "Client-ID 9C3O-Dt7AQEgrcVKBPwUpynL1z3x0uZCbUM-UTr1how"]
    }

    var path: String {
        switch self {
        case .getSearchImage: return "search/photos"
        }
    }

    func createSearchRequest(query: String, page: Int) -> URLRequest {
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let path = path + "?per_page=30&page=\(page)&query=\(query!)"
        let url = URL(string: path, relativeTo: baseURL)
        var request = URLRequest(url: url!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        return request
    }
}
