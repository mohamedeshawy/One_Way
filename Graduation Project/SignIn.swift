//
//  SignIn.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 2/14/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class SignIn: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var passengerOrDriver : Bool = false  // passenger = false  ,   driver = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let font = UIFont.systemFont(ofSize: 18)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
    }
    
    @IBAction func login(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion:{ (user,error) in
            if error != nil{
                self.errorLabel.text = error?.localizedDescription
            }
            else{
                self.errorLabel.text = ""
                print("Logged In")
                // segue to map view
                
            }
        })
    }
    
    
    @IBAction func segmentedControl(_ sender: Any) {
        emailTextField.text = ""
        passwordTextField.text = ""
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            passengerOrDriver = false
            print("passenger")
        default:
            passengerOrDriver = true
            print("driver")
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
