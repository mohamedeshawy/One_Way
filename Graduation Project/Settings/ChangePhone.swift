//
//  ChangePicture.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 6/20/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChangePhone: UIViewController {
    var model:Model?
    var myDelegate:Delegate?
    @IBOutlet weak var newPhone: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("change phone")
    }

    @IBAction func changeDone(_ sender: Any) {
        guard model != nil else {
            print("the model is nil")
            return
        }
        if Auth.auth().currentUser != nil {
            PhoneAuthProvider.provider().verifyPhoneNumber(self.newPhone.text!, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    self.errorLabel.text = error.localizedDescription
                    return
                }
                // Sign in using the verificationID and the code sent to the user
                self.errorLabel.text = "you will receive the verification code"
                let alert = UIAlertController(title: "verification".capitalized, message: "Please enter the verification code", preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (verificationCode) in
                    verificationCode.placeholder = "enter the code"
                })
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                    let credential = PhoneAuthProvider.provider().credential(
                        withVerificationID: verificationID!,
                        verificationCode: alert.textFields![0].text!)
                        Auth.auth().signIn(with: credential, completion: { (user, error) in
                            if let error = error {
                                self.errorLabel.text = error.localizedDescription
                                return
                            }
                            self.errorLabel.text = ""
                            let ref = Database.database().reference(fromURL: "https://oneway-500ad.firebaseio.com/").child("drivers/"+(self.model?.uid)!)
                            //Update new data in the database
                            print(alert.textFields![0].text!)
                            ref.updateChildValues(["Phone_Number":"\(self.newPhone.text!)"])
                            print("phone number is updated !!")
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(alertAction)
                alert.addAction(alertCancel)
                self.present(alert, animated: true, completion: nil)
            }
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
