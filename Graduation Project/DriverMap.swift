//
//  DriverMap.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 2/25/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire
import SwiftyJSON
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import Mapbox

class DriverMap: UIViewController, MGLMapViewDelegate, NavigationViewControllerDelegate, CLLocationManagerDelegate {
    var driver : Model?
    var location : CLLocation?
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    var legs : [Legs] = []
    
    var timer: Timer?
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]!
 
    var locations_lat = [String]()
    var locations_lng = [String]()
    var arrayOfLocations = Array<String>()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
        
        let camera = GMSCameraPosition.camera(withLatitude: 29.97371, longitude: 32.52627, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 100, y: 100, width: 400, height: 550), camera: camera)
        mapView?.center = self.view.center
        self.view.addSubview(mapView!)
      
        mapView.delegate = self as? GMSMapViewDelegate
        mapView.isMyLocationEnabled = true
        mapView.camera = camera
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures  = true
        
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
        print(location as Any)
        let locationIsmaeilia = CLLocation(latitude: 30.60427, longitude: 32.27225)
        let locationPort_said = CLLocation(latitude: 31.25654, longitude: 32.28411)
        let sharmelsheik = CLLocation(latitude: 27.91582, longitude: 34.32995)
        let el_Ghardaka = CLLocation(latitude: 27.25738 , longitude: 33.81291)
        
        createMarker(titleMarker: "Ismaeilia", latitude: locationIsmaeilia.coordinate.latitude, longitude: locationIsmaeilia.coordinate.longitude)
        
        createMarker(titleMarker: "Suez", latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        createMarker(titleMarker: "port_said", latitude: locationPort_said.coordinate.latitude , longitude: locationPort_said.coordinate.longitude)
        createMarker(titleMarker: "Sharm el_Sheik", latitude:sharmelsheik.coordinate.latitude, longitude: sharmelsheik.coordinate.longitude)
        createMarker(titleMarker: "El_Ghardaka", latitude: el_Ghardaka.coordinate.latitude, longitude: el_Ghardaka.coordinate.longitude)
        drawPath()
        self.locationManager.stopUpdatingLocation()
    }
    func drawPath()
    {
        let url = URL(string :"https://maps.googleapis.com/maps/api/directions/json?origin=27.856471,34.279848000000015&destination= 27.180494,33.80756599999995&waypoints=optimize:true| 27.856471,34.279848000000015 |29.9668343,32.54980690000002|31.26528929999999,32.301866099999984|30.5964923,32.27145870000004&mode=driving".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseJSON(json: json["routes"].array![0]["legs"])
            case .failure(let error):
                print(error)
            }
            do{
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                // draw route using Polyline
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.mapView
                }
            } // end of do
            catch{
            } // end of catch
        }
    }
    func parseJSON(json:JSON) {
        print("start parsing...")
        for (_,subJson):(String, JSON) in json {
            let distance : String = subJson["distance"]["text"].stringValue
            let duration : String = subJson["duration"]["text"].stringValue
            let end_address : String = subJson["end_address"].stringValue
            let end_location_lat : String = subJson["end_location"]["lat"].stringValue
            let end_location_lng : String = subJson["end_location"]["lng"].stringValue
            let start_address : String = subJson["start_address"].stringValue
            let start_location_lat : String = subJson["start_location"]["lat"].stringValue
            let start_location_lng : String = subJson["start_location"]["lng"].stringValue
            var steps : [Step] = []
            for (_,sub):(String, JSON) in subJson["steps"] {
                let step = Step(distance: sub["distance"]["text"].stringValue, duration: sub["duration"]["text"].stringValue, end_location_lat: sub["end_location"]["lat"].stringValue, end_location_lng: sub["end_location"]["lng"].stringValue, start_location_lat: sub["start_location"]["lat"].stringValue, start_location_lng: sub["start_location"]["lng"].stringValue)
                steps.append(step)
            }
            let leg = Legs(distance: distance, duration: duration, end_address: end_address, end_location_lat: end_location_lat, end_location_lng: end_location_lng, start_address: start_address, start_location_lat: start_location_lat, start_location_lng: start_location_lng, steps: steps)
            legs.append(leg)
        }
    }
    //Mark:   start Navigation
    func startNavigation(){
        
        let waypointOne =  CLLocationCoordinate2D(latitude: 37.777954, longitude: -122.426871)
        let waypointTwo =  CLLocationCoordinate2D(latitude: 37.777552, longitude: -122.432772)
        let waypointThree = CLLocationCoordinate2D(latitude: 37.777662, longitude: -122.431892)
        let wayPointFour = CLLocationCoordinate2D(latitude: 37.780399, longitude: -122.425358)
        print("@@@@@@@@@@@@@@@@@@")
        let options = NavigationRouteOptions(coordinates: [waypointOne, waypointTwo, waypointThree, wayPointFour], profileIdentifier: .automobile)
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




