//
//  model.swift
//  Graduation Project
//
//  Created by Mahmoud Ismaeil Atito on 2/19/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import Foundation

class Model{
    var uid = String()
    var name = String()
    var email = String()
    var phone = String()
    var photoUrl : String?
    
    init(uid: String,name : String, email:String, phone:String, photoUrl: String!) {
        self.uid = uid
        self.name = name
        self.email = email
        self.phone = phone
        self.photoUrl = photoUrl
        print("UID : \(uid)")
        print("Name : \(name)")
        print("Email : \(email)")
        print("PhoneNo : \(phone)")
        print("photoURL : \(photoUrl)")
    }
}
