//
//  DriverMap.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 2/25/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class DriverMap: UIViewController,CLLocationManagerDelegate {
    var driver : Model?
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var steps : [RouteStep] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        guard let driver = driver else {
            return
        }
        print("name : \(driver.name)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        guard let location = currentLocation  else {
            print("current location is nil")
            return
        }
        print(location)
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(location.coordinate.latitude),\(location.coordinate.longitude)&destination= 27.180494, 33.80756599999995&waypoints=optimize:true| 27.856471,34.279848000000015 |29.9668343,32.54980690000002|31.26528929999999,32.301866099999984|30.5964923,32.27145870000004&key=AIzaSyC12fYEo7jiJ4bbLNZUg2s9RzIaYa7uvs0".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseJSON(legs: json["routes"].array![0]["legs"])
            case .failure(let error):
                print(error)
            }
        }
        locationManager.stopUpdatingLocation()
    }
    func parseJSON(legs:JSON) {
        print("start parsing...")
        for (_,subJson):(String, JSON) in legs {
            // Do something you want
            //print(subJson["distance"]["text"])
            let distance : String = subJson["distance"]["text"].stringValue
            let duration : String = subJson["duration"]["text"].stringValue
            let end_address : String = subJson["end_address"].stringValue
            let end_location_lat : String = subJson["end_location"]["lat"].stringValue
            let end_location_lng : String = subJson["end_location"]["lng"].stringValue
            let start_address : String = subJson["start_address"].stringValue
            let start_location_lat : String = subJson["start_location"]["lat"].stringValue
            let start_location_lng : String = subJson["start_location"]["lng"].stringValue
            let routeStep = RouteStep(distance: distance, duration: duration, end_address: end_address, end_location_lat: end_location_lat, end_location_lng: end_location_lng, start_address: start_address, start_location_lat: start_location_lat, start_location_lng: start_location_lng)
            steps.append(routeStep)
        }
        print(steps.count)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
