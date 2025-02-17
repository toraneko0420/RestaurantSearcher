//
//  RestaurantData.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/26.
//

import Foundation

class RestaurantData: ObservableObject {
    
    @Published var restaurantList: [RestaurantItem] = []
    
    // JSONのデータ構造
    struct ResultJson: Codable {
        let results: Results
        
        struct Results: Codable {
            let shop: [Shop]
            
            struct Shop: Codable {
                let name: String
                let address: String
                let logo_image: URL?
                let open: String
                let access: String
                let photo: Photo?
                
                struct Photo: Codable {
                    let pc: PC?
                    
                    struct PC: Codable {
                        let l: URL?
                        let m: URL?
                        let s: URL?
                    }
                }
            }
        }
    }
    
    // リストをクリア
    func clearList() {
        self.restaurantList.removeAll()
    }
    
    // 現在地周辺の飲食店を検索
    func searchRestaurant(keyword: String, latitude: Double, longitude: Double, range: Int) async {
        // APIキーを設定
        let apiKey = "8298d5ff0f151603"
        
        // リクエストURLを作成
        guard let req_url = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apiKey)&keyword=\(keyword)&lat=\(latitude)&lng=\(longitude)&range=\(range)&format=json")
        else {
            print("Invalid URL")
            return
        }
        print(req_url)
        
        do {
            let (data, _) = try await URLSession.shared.data(from: req_url)
            
            let decoder = JSONDecoder()
            
            let json = try decoder.decode(ResultJson.self, from: data)
            
            DispatchQueue.main.async {
                self.clearList()
                for shop in json.results.shop {
                    let restaurant = RestaurantItem(
                        name: shop.name,
                        image: shop.logo_image,
                        address: shop.address,
                        open: shop.open,
                        access: shop.access,
                        photoPC: shop.photo?.pc?.l
                    )
                    self.restaurantList.append(restaurant)
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
