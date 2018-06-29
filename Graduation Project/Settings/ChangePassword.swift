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
        if let currentUser = Auth.auth().currentUser {
            let ref = Database.database().reference(fromURL: "https://oneway-500ad.firebaseio.com/").child("drivers/"+currentUser.uid)
            ref.observeSingleEvent(of: .value, with: { (dataSnapshot) in
                let data = dataSnapshot.value as! NSDictionary
                let oldPassword = data["Password"] as? String
                if oldPassword == self.oldPassword.text {
                    self.errorLabel.text = ""
                    Auth.auth().currentUser?.updatePassword(to: self.newPassword.text!) { (error) in
                        if let error = error  {
                            self.errorLabel.text = error.localizedDescription
                        }
                        else {
                            self.errorLabel.text = ""
                            //Update new data in the database
                            ref.updateChildValues(["Password":"\(self.newPassword.text!)"])
                            print("password is updated")
                            //Re Auth ....
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                else {
                    self.errorLabel.text = "Please check the old password"
                    return
                }
            })
        }
        else {
            print("the current user is nil")
            return
        }
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
