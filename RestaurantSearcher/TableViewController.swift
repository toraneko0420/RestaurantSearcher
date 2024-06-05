//
//  TableViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/28.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var restaurantList: [RestaurantItem] = [] // 表示したいデータソース
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    //縦幅を設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    // TableViewの行数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    // TableViewのセルを構築して返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as? RestaurantTableViewCell else {
            print("failed RestaurantTableViewCell.")
            return UITableViewCell()
        }
        let restaurant = restaurantList[indexPath.row]
        cell.configure(with: restaurant)
        return cell
    }
    
    // セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailSegue", sender: indexPath)
    }

    // Segueの準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            if let detailVC = segue.destination as? DetailViewController {
                if let indexPath = sender as? IndexPath {
                    let selectedRestaurant = restaurantList[indexPath.row]
                    detailVC.restaurant = selectedRestaurant
                    print("\(selectedRestaurant)")
                } else {
                    print(IndexPath.self)
                }
            } else {
                print("error: DetailViewController")
            }
        }
    }
}

//指定された URL から画像を非同期でロード
extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
