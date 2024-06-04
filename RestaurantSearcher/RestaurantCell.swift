//
//  RestaurantCell.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/28.
//

import UIKit

class RestaurantCell: UITableViewCell {
    let restaurantImageView = UIImageView()
    let nameLabel = UILabel()
    let addressLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // Configure and add subviews
        restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(restaurantImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)

        // Setup constraints
        NSLayoutConstraint.activate([
            restaurantImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            restaurantImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            restaurantImageView.widthAnchor.constraint(equalToConstant: 60),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        if let url = URL(string: restaurant.imageUrl) {
            restaurantImageView.loadImage(from: url)
        }
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        // Load image asynchronously
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

