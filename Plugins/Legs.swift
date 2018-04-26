//
//  RouteStep.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 3/8/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import Foundation
class Legs {
    var end_address : String
    var end_location_lat : Double
    var end_location_lng : Double
    var start_address : String
    var start_location_lat : Double
    var start_location_lng : Double
    
    init(end_address : String,end_location_lat : Double,end_location_lng : Double,start_address : String,start_location_lat : Double,start_location_lng : Double) {
        self.end_address = end_address
        self.end_location_lat = end_location_lat
        self.end_location_lng = end_location_lng
        self.start_address = start_address
        self.start_location_lat = start_location_lat
        self.start_location_lng = start_location_lng
    }
}


