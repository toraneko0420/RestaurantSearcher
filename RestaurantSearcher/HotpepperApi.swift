//
//  HotpepperApi.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/27.
//

import Foundation

class HotPepperAPIClient {
    private let baseURL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"

    func fetchRestaurantsNearby(location: Location, completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        let urlString = "\(baseURL)?key=\(apiKey)&lat=\(location.latitude)&lng=\(location.longitude)&range=3&format=json"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 204, userInfo: nil)))
                return
            }

            do {
                let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(searchResponse.results.shop))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
