//
//  ChangeEmail.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 6/20/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChangeEmail: UIViewController {
    var model:Model?
    var myDelegate : Delegate?
    @IBOutlet weak var oldEmail: UITextField!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("change Email")
        guard model != nil else {
            print("the model is nil")
            return
        }
        oldEmail.text = model?.email
    }
    @IBAction func changeDone(_ sender: Any) {
        if let currentUser = Auth.auth().currentUser {
            let ref = Database.database().reference(fromURL: "https://oneway-500ad.firebaseio.com/").child("drivers/"+currentUser.uid)
            currentUser.updateEmail(to: self.newEmail.text!, completion: {
                (error) in
                if let error = error {
                    self.errorLabel.text = error.localizedDescription
                    return
                }
                else {
                    self.errorLabel.text = ""
                    currentUser.sendEmailVerification {
                        (error) in
                        if let error = error {
                            self.errorLabel.text = error.localizedDescription
                            return
                        }
                        else {
                            self.errorLabel.text = ""
                            //Update new data in the database
                            ref.updateChildValues(["Email":"\(self.newEmail.text!)"])
                            
                            //passing back the new data
                            self.model?.email = self.newEmail.text!
                            self.myDelegate?.passingModel(model: self.model!)
                            self.navigationController?.popViewController(animated: true)
                            }
                    }
                }
            })
        }
        else {
            print("the current user is nil")
            return
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
