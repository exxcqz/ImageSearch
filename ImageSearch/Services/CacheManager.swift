//
//  CacheManager.swift
//  ImageSearch
//
//  Created by Nikita Gavrikov on 31.01.2022.
//

import Foundation

class CacheManager {
    static let cache = NSCache<AnyObject, AnyObject>()

    private init() {}
}
