//
//  SearchResponse.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/28.
//

import Foundation

struct SearchResponse: Codable {
    let results: Results

    struct Results: Codable {
        let shop: [Restaurant]
    }
}
