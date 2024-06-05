//
//  DetailViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/06/04.
//

import UIKit

class DetailViewController: UIViewController {
    
    var restaurant: RestaurantItem?

       @IBOutlet weak var nameLabel: UILabel!
       @IBOutlet weak var addressLabel: UILabel!
       @IBOutlet weak var openLabel: UILabel!
       @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurant = restaurant {
            nameLabel.text = restaurant.name
            addressLabel.text = restaurant.address
            openLabel.text = "営業時間： \(restaurant.open)"

            if let imageUrl = restaurant.photoPC {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let error = error {
                        print("Error loading image: \(error)")
                        return
                    }
                    guard let data = data else {
                        print("No image data received")
                        return
                    }
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }.resume()
            }
        }
    }
}
