//
//  RouteStep.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 3/8/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import Foundation
class Legs {
    var distance : String
    var duration : String
    var end_address : String
    var end_location_lat : String
    var end_location_lng : String
    var start_address : String
    var start_location_lat : String
    var start_location_lng : String
    var Step : [Step]
    
    init(distance : String,duration : String,end_address : String,end_location_lat : String,end_location_lng : String,start_address : String,start_location_lat : String,start_location_lng : String,steps : [Step]) {
        self.distance = distance
        self.duration = duration
        self.end_address = end_address
        self.end_location_lat = end_location_lat
        self.end_location_lng = end_location_lng
        self.start_address = start_address
        self.start_location_lat = start_location_lat
        self.start_location_lng = start_location_lng
        self.Step = steps
    }
}
class Step {
    var distance : String
    var duration : String
    var end_location_lat : String
    var end_location_lng : String
    var start_location_lat : String
    var start_location_lng : String
    
    init(distance : String,duration : String,end_location_lat : String,end_location_lng : String,start_location_lat : String,start_location_lng : String) {
        self.distance = distance
        self.duration = duration
        self.end_location_lat = end_location_lat
        self.end_location_lng = end_location_lng
        self.start_location_lat = start_location_lat
        self.start_location_lng = start_location_lng
    }
}

