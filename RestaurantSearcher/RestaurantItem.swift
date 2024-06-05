//
//  RestaurantItem.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/28.
//

import Foundation

// レストラン情報を格納するモデル
struct RestaurantItem: Identifiable {
    var id = UUID()
    let name: String
    let image: URL?
    let address: String
    let open: String
    let access: String
    let photoPC: URL?
}
