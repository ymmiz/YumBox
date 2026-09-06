//
//  MapViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 22/09/2024.
//

import UIKit
import GoogleMaps
 
class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 14.0)
        let options = GMSMapViewOptions()
        options.camera = camera
        options.frame = self.view.bounds
        mapView = GMSMapView(options: options)
        self.view.addSubview(mapView ?? GMSMapView())
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        mapView.camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 14.0)
        fetchNearbyMarts(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    }
    
    func fetchNearbyMarts(latitude: Double, longitude: Double) {
        let radius = 2000 // in meters
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String,
              !apiKey.isEmpty else {
            print("Google Maps API key is not configured.")
            return
        }
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&type=store&keyword=supermarket&key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching places: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.addMarkers(for: results)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func addMarkers(for places: [[String: Any]]) {
        for place in places {
            if let geometry = place["geometry"] as? [String: Any],
               let location = geometry["location"] as? [String: Any],
               let lat = location["lat"] as? Double,
               let lng = location["lng"] as? Double,
               let name = place["name"] as? String {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                marker.title = name
                marker.map = mapView
            }
        }
    }
}
