//
//  DriverMap.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 2/25/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class DriverMap: UIViewController,GMSMapViewDelegate, NavigationViewControllerDelegate, CLLocationManagerDelegate {
    var driver : Model?
    var location : CLLocation?
    let locationManager = CLLocationManager()
    //var mapView: GMSMapView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var legs : [Legs] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
        
        let camera = GMSCameraPosition.camera(withLatitude: 29.97371, longitude: 32.52627, zoom: 6.0)
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.zoomGestures  = true
        
        guard let driver = driver else {
            return
        }
        print("name : \(driver.name)")
    }
    
    // Mark: function to create markers
    func createMarker(titleMarker: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.title = titleMarker
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.map = self.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations.last
        drawPath()
        self.locationManager.stopUpdatingLocation()
    }
    func drawPath()
    {
        guard let myLocation = location else {
            print("my location is nil")
            return
        }
        let url = URL(string :"https://maps.googleapis.com/maps/api/directions/json?origin=\(myLocation.coordinate.latitude),\(myLocation.coordinate.longitude)&destination= 27.856471,34.279848000000015&waypoints=optimize:true| 30.1197986,31.537000300000045 |30.5964923,32.27145870000004|31.26528929999999,32.301866099999984|27.2578957,33.81160669999997&key=AIzaSyCUvykBxZZurYGh8dgWAMI4D0E2GKoZPUA".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // draw route using Polyline
                print(json)
                for (_,route) in json["routes"]
                {
                    let points = route["overview_polyline"]["points"].stringValue
                    let path = GMSPath(fromEncodedPath: points)
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.mapView
                }
                self.parseJSON(json: json["routes"].array![0]["legs"])
            case .failure(let error):
                print(error)
            }
        }
    }
    func parseJSON(json:JSON) {
        print("start parsing...")
        createMarker(titleMarker: json.array![0]["start_address"].stringValue, latitude: json.array![0]["start_location"]["lat"].doubleValue, longitude: json.array![0]["start_location"]["lng"].doubleValue)
        legs.removeAll()
        for (_,subJson):(String, JSON) in json {
            let distance : String = subJson["distance"]["text"].stringValue
            let duration : String = subJson["duration"]["text"].stringValue
            let end_address : String = subJson["end_address"].stringValue
            let end_location_lat = subJson["end_location"]["lat"].doubleValue
            let end_location_lng = subJson["end_location"]["lng"].doubleValue
            let start_address : String = subJson["start_address"].stringValue
            let start_location_lat = subJson["start_location"]["lat"].doubleValue
            let start_location_lng = subJson["start_location"]["lng"].doubleValue
            createMarker(titleMarker: end_address, latitude: end_location_lat, longitude: end_location_lng)
            let leg = Legs(distance: distance, duration: duration, end_address: end_address, end_location_lat: end_location_lat, end_location_lng: end_location_lng, start_address: start_address, start_location_lat: start_location_lat, start_location_lng: start_location_lng)
            legs.append(leg)
        }
    }
    //Mark:   start Navigation
    func startNavigation(){
        var wayPoints : [Waypoint]=[]
        wayPoints.append(Waypoint(coordinate: CLLocationCoordinate2D(latitude: legs[0].start_location_lat, longitude: legs[0].start_location_lng), name: legs[0].start_address))
        for wayPoint in legs {
            wayPoints.append(Waypoint(coordinate: CLLocationCoordinate2D(latitude: wayPoint.end_location_lat, longitude: wayPoint.end_location_lng), name: wayPoint.end_address))
        }
        print("@@@@@@@@@@@@@@@@@@\(wayPoints.count)")
        let options = NavigationRouteOptions(waypoints: wayPoints, profileIdentifier: .automobile)
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first, error == nil else {
                print(error!.localizedDescription)
                return
            }
            let navigationController = NavigationViewController(for: route)
            navigationController.delegate = self
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    // Show an alert when arriving at the waypoint and wait until the user to start next leg.
    func navigationViewController(_ navigationViewController: NavigationViewController, didArriveAt waypoint: Waypoint) -> Bool {
        let alert = UIAlertController(title: "Arrived at \(String(describing: waypoint.name))", message: "Continue your way?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            // Begin the next leg once the driver confirms
            navigationViewController.routeController.routeProgress.legIndex += 1
            
        }))
        navigationViewController.present(alert, animated: true, completion: nil)
        
        return false
    }
    
    
    @IBAction func start_Navigation(_ sender: Any) {
        startNavigation()
    }
}




