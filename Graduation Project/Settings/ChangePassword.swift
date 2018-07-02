//
//  ChangePassword.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 6/20/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SKActivityIndicatorView
class ChangePassword: UIViewController {
    var model:Model?
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("change password")
    }
    @IBAction func doneAction(_ sender: Any) {
        guard model != nil else {
            print("model is nil")
            return
        }
        self.errorLabel.text = ""
        if let currentUser = Auth.auth().currentUser {
            SKActivityIndicator.show("Loading...")
            let ref = Database.database().reference(fromURL: "https://oneway-500ad.firebaseio.com/").child("drivers/"+currentUser.uid)
            ref.observeSingleEvent(of: .value, with: { (dataSnapshot) in
                let data = dataSnapshot.value as! NSDictionary
                let oldPassword = data["Password"] as? String
                if oldPassword == self.oldPassword.text {
                    self.errorLabel.text = ""
                    Auth.auth().currentUser?.updatePassword(to: self.newPassword.text!) { (error) in
                        if let error = error  {
                            self.errorLabel.text = error.localizedDescription
                            SKActivityIndicator.dismiss()
                            return
                        }
                        else {
                            self.errorLabel.text = ""
                            //Update new data in the database
                            ref.updateChildValues(["Password":"\(self.newPassword.text!)"])
                            print("password is updated")
                            SKActivityIndicator.dismiss()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                else {
                    self.errorLabel.text = "Please check the old password"
                    SKActivityIndicator.dismiss()
                    return
                }
            })
        }
        else {
            print("the current user is nil")
            return
        }
    }
}
