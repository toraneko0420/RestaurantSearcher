//
//  ViewController.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2024/05/24.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var showTableViewButton: UIButton!
    
    @IBOutlet weak var radius300Button: UIButton!
    @IBOutlet weak var radius500Button: UIButton!
    @IBOutlet weak var radius1000Button: UIButton!
    @IBOutlet weak var radius2000Button: UIButton!
    @IBOutlet weak var radius3000Button: UIButton!

    var locationManager: CLLocationManager!
    var restaurantData = RestaurantData()
    var restaurantList: [RestaurantItem] = []
    var selectedSearchRadius: Int = 3 // 初期値が3 (1000m)
    var currentKeyword: String = "" // 現在の検索キーワード
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        mapView.delegate = self
        
        // 位置情報の設定
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //ユーザーに位置情報の使用許可をリクエスト
        locationManager.startUpdatingLocation() //位置情報の更新
        
        radius300Button.addTarget(self, action: #selector(radiusButton(_:)), for: .touchUpInside)
        radius500Button.addTarget(self, action: #selector(radiusButton(_:)), for: .touchUpInside)
        radius1000Button.addTarget(self, action: #selector(radiusButton(_:)), for: .touchUpInside)
        radius2000Button.addTarget(self, action: #selector(radiusButton(_:)), for: .touchUpInside)
        radius3000Button.addTarget(self, action: #selector(radiusButton(_:)), for: .touchUpInside)
        
        //キーボードを下げる
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapScreen)
    }
    
    // キーボードを下げるメソッド
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func radiusButton(_ sender: UIButton) {
        switch sender {
        case radius300Button:
            selectedSearchRadius = 1
        case radius500Button:
            selectedSearchRadius = 2
        case radius1000Button:
            selectedSearchRadius = 3
        case radius2000Button:
            selectedSearchRadius = 4
        case radius3000Button:
            selectedSearchRadius = 5
        default:
            selectedSearchRadius = 3
        }
        
        guard let keyword = searchBar.text else { return }
        currentKeyword = keyword
        if let location = locationManager.location {
            searchRestaurants(location: location, keyword: keyword)
        }
    }
    
    //周辺の飲食店を検索
    func searchRestaurants(location: CLLocation, keyword: String = "") {
        Task {
            await restaurantData.searchRestaurant(keyword: keyword, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, range: selectedSearchRadius)
            restaurantList = restaurantData.restaurantList
            MapAnnotations()
        }
    }
    
    //位置情報が更新
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let radiusOptions = [300, 500, 1000, 2000, 3000]
            let radius = CLLocationDistance(radiusOptions[selectedSearchRadius - 1])
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius * 2, longitudinalMeters: radius * 2)
            mapView.setRegion(coordinateRegion, animated: true)
            searchRestaurants(location: location)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    //検索バーの検索ボタンがクリックされたとき
    func searchBarButton(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        currentKeyword = keyword
        if let location = locationManager.location {
            searchRestaurants(location: location, keyword: keyword)
        }
    }
    
    //アノテーションを作成
    func MapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        for restaurant in restaurantList {
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.subtitle = restaurant.address
            getAddress(address: restaurant.address) { coordinates in
                guard let coordinates = coordinates else { return }
                annotation.coordinate = coordinates
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    //指定された住所を緯度と経度に変換する
    func getAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                completion(nil)
            }
        }
    }
    
    // Segueの準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTableViewSegue" {
            // 遷移先のViewControllerを取得
            if let destinationVC = segue.destination as? TableViewController {
                destinationVC.restaurantList = restaurantList
            }
        }
    }
}
