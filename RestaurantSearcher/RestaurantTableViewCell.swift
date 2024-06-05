//
//  RestaurantTableViewCell.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/29.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    func configure(with restaurant: RestaurantItem) {
        nameLabel.text = restaurant.name
        accessLabel.text = restaurant.access
        if let imageUrl = restaurant.image {
            restaurantImageView.loadImage(from: imageUrl)
        }
    }
}
