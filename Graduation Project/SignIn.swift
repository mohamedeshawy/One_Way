//
//  SignIn.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 2/14/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.



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
    // load From Database
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
        let font = UIFont.systemFont(ofSize: 18)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
    }
    
    // MARK:- Sign IN
    
    @IBAction func login(_ sender: Any) {
        
        
        let rootRef = Database.database().reference()
        Auth.auth().addStateDidChangeListener({auth, user in
            
            if self.passengerOrDriver == false { // if user is a passenger
                
                if user != nil {
                    Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion:{ (user,error) in
                        if error != nil{
                            self.errorLabel.text = error?.localizedDescription
                        }
                        else{
                            self.errorLabel.text = ""
                            let user = Auth.auth().currentUser
                            let  uid = user?.uid
                            
                            rootRef.child("passengers").child(uid!).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                                
                                if (snapshot.exists()) {
                                    // is a passenger
                                    print("logged in as a passenger")
                                    
                                    // move to map view of a passenger
                                    
                                }
                                else{
                                    self.errorLabel.text = "You Are not A Passenger"
                                }
                            })
                        }
                    })
                }
            }
                
                //if user is a driver
            else if self.passengerOrDriver == true{
                if user != nil {
                    
                    Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion:{ (user,error) in
                        if error != nil{
                            self.errorLabel.text = error?.localizedDescription
                        }
                        else{
                            self.errorLabel.text = ""
                            let user = Auth.auth().currentUser
                            let  uid = user?.uid
                            
                            rootRef.child("drivers").child(uid!).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                                
                                if (snapshot.exists()) {
                                    // is a driver
                                    print("logged in as a driver")
                                    
                                    // move to map view of a driver
                                }
                                else{
                                    self.errorLabel.text = "You Are not A Driver"
                                }
                            })
                        }
                    })
                }
            }
            
        })
        
        
    }
    
    
    @IBAction func segmentedControl(_ sender: Any) {
        emailTextField.text = ""
        passwordTextField.text = ""
        errorLabel.text = ""
        
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

