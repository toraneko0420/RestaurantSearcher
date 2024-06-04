//
//  RestaurantItem.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/28.
//

import Foundation

struct RestaurantItem: Identifiable {
    let id = UUID()
    let name: String
    let image: URL?
    let address: String
    let open: String 
}
