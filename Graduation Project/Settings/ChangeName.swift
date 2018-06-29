//
//  ChangeName.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 6/20/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChangeName: UIViewController {
    var model:Model?
    var myDelegate:Delegate?
    @IBOutlet weak var oldName: UITextField!
    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("change name")
        guard model != nil else {
            print("the model is nil")
            return
        }
        self.oldName.text = self.model?.name
    }

    @IBAction func ChangeDone(_ sender: Any) {
        if let currentUser = Auth.auth().currentUser {
            let ref = Database.database().reference(fromURL: "https://oneway-500ad.firebaseio.com/").child("drivers/"+currentUser.uid)
            self.errorLabel.text = ""
            //Update new data in the database
            ref.updateChildValues(["Name":"\(self.newName.text!)"])
            
            //passing back the new data
            self.model?.name = self.newName.text!
            self.myDelegate?.passingModel(model: self.model!)
            self.navigationController?.popViewController(animated: true)
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
