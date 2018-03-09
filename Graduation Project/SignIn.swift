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
    var model : Model?
    
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
                            guard let uid = user?.uid else {
                                return
                            }
                            rootRef.child("passengers").child(uid).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                                if (snapshot.exists()) {
                                    // is a passenger
                                    let data = snapshot.value as! NSDictionary
                                    let OptionalName = data["Name"] as? String
                                    let OptionalEmail = data["Email"] as? String
                                    let OptionalPhone = data["Phone_Number"] as? String
                                    let OptionalPhotoURL = data["downloadURL"] as? String
                                    guard let name = OptionalName,let email = OptionalEmail,let phone = OptionalPhone,let photoUrl=OptionalPhotoURL else {
                                        print("the name or email or phone or photoUrl is a nil value")
                                        return
                                    }
                                    self.model = Model(uid: uid, name: name, email: email, phone: phone, photoUrl: photoUrl)
                                    print("logged in as a passenger")
                                    // move to map view of a passenger
                                    let passengerVC = self.storyboard?.instantiateViewController(withIdentifier: "passenger") as! PassengerMap
                                    passengerVC.passenger = self.model
                                    self.present(passengerVC, animated: true, completion: nil)
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
                            guard let uid = user?.uid else {
                                return
                            }
                            rootRef.child("drivers").child(uid).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                                if (snapshot.exists()) {
                                    let data = snapshot.value as! NSDictionary
                                    let OptionalName = data["Name"] as? String
                                    let OptionalEmail = data["Email"] as? String
                                    let OptionalPhone = data["Phone_Number"] as? String
                                    let OptionalPhotoURL = data["downloadURL"] as? String
                                    guard let name = OptionalName,let email = OptionalEmail,let phone = OptionalPhone,let photoUrl=OptionalPhotoURL else {
                                        print("the name or email or phone or photoUrl is a nil value")
                                        return
                                    }
                                    self.model = Model(uid: uid, name: name, email: email, phone: phone, photoUrl: photoUrl)
                                    // is a driver
                                    print("logged in as a driver")
                                    // move to map view of a driver
                                    let driverVC = self.storyboard?.instantiateViewController(withIdentifier: "driver") as! DriverMap
                                    driverVC.driver = self.model
                                    self.present(driverVC, animated: true, completion: nil)
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

