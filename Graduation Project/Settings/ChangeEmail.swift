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
import SKActivityIndicatorView
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
        self.errorLabel.text = ""
        if let currentUser = Auth.auth().currentUser {
            SKActivityIndicator.show("Loading...")
            let ref = Database.database().reference(fromURL: "https://oneway-500ad.firebaseio.com/").child("drivers/"+currentUser.uid)
            currentUser.updateEmail(to: self.newEmail.text!, completion: {
                (error) in
                if let error = error {
                    self.errorLabel.text = error.localizedDescription
                    SKActivityIndicator.dismiss()
                    return
                }
                else {
                    self.errorLabel.text = ""
                    currentUser.sendEmailVerification {
                        (error) in
                        if let error = error {
                            self.errorLabel.text = error.localizedDescription
                            SKActivityIndicator.dismiss()
                            return
                        }
                        else {
                            ref.observeSingleEvent(of: .value, with: { (data : DataSnapshot) in
                                let dic = data.value as! NSDictionary
                                let credential: AuthCredential = EmailAuthProvider.credential(withEmail: self.newEmail.text!, password: dic["Password"] as! String)
                                currentUser.reauthenticate(with: credential) { error in
                                    if let error = error {
                                        self.errorLabel.text = error.localizedDescription
                                        SKActivityIndicator.dismiss()
                                        return
                                    }
                                    self.errorLabel.text = ""
                                    //Update new data in the database
                                    ref.updateChildValues(["Email":"\(self.newEmail.text!)"])
                                    
                                    //passing back the new data
                                    self.model?.email = self.newEmail.text!
                                    self.myDelegate?.passingModel(model: self.model!)
                                    SKActivityIndicator.dismiss()
                                    self.navigationController?.popViewController(animated: true)
                                }
                                
                            })
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
}
