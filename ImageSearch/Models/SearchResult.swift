//
//  SearchResult.swift
//  ImageSearch
//
//  Created by Nikita Gavrikov on 29.01.2022.
//

import Foundation

struct SearchResult: Codable {
    let total: Int
    let totalPages: Int
    let results: [ImageInfo]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
