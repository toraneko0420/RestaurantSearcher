//
//  RestaurantTableViewCell.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/29.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    func configure(with restaurant: RestaurantItem) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        openLabel.text = "営業時間: \(restaurant.open)"
        if let imageUrl = restaurant.image {
            restaurantImageView.loadImage(from: imageUrl)
        }
    }
}
