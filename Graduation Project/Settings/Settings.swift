//
//  Settings.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 6/20/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//
import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SKActivityIndicatorView

class Settings: UITableViewController, Delegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    let imagePicker = UIImagePickerController()
    var driver : Model?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let driver=self.driver else {
            print("the driver is nil")
            return
        }
        print(driver.name)
        let url = URL(string: driver.photoUrl!)
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "img") )
        imagePicker.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.imageView.addGestureRecognizer(gesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let driver=self.driver else {
            print("the driver is nil")
            return
        }
        print(driver.name)
        name.text = driver.name
        email.text = driver.email
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        // do other task
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.errorLabel.text = ""
        SKActivityIndicator.show("Uploading...")
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = pickedImage
            let ref = Database.database().reference(fromURL: "https://oneway-500ad.firebaseio.com/").child("drivers").child((driver?.uid)!)
            let imgRef = Storage.storage().reference(forURL: "gs://oneway-500ad.appspot.com/")
            if let ImageData = UIImageJPEGRepresentation(imageView.image!, 0.8){
                let driverImageRef = imgRef.child("drivers").child((self.driver?.uid)!+"/UserImage.jpg")
                driverImageRef.putData(ImageData, metadata: nil, completion: {
                    (metaData,error) in
                    if let error = error {
                        self.errorLabel.text = error.localizedDescription
                        SKActivityIndicator.dismiss()
                        return
                    }
                    else {
                        let downloadURL = metaData!.downloadURL()!.absoluteString
                        ref.updateChildValues(["downloadURL": downloadURL])
                        self.driver?.photoUrl = downloadURL
                        print("picture is uploaded")
                        SKActivityIndicator.dismiss()
                    }
                })
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: "toEmail", sender: self)
        }
        else if indexPath.row == 2 {
            performSegue(withIdentifier: "toName", sender: self)
        }
        else if indexPath.row == 3 {
            performSegue(withIdentifier: "toPassword", sender: self)
        }
        else if indexPath.row == 4 {
            performSegue(withIdentifier: "toPhone", sender: self)
        }
        else if indexPath.row == 5 {
            let alert = UIAlertController(title: "Delete Account", message: "Are you sure?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: {(alertAction) in
                let user = Auth.auth().currentUser
                
                user?.delete { error in
                    if let error = error {
                        self.errorLabel.text = error.localizedDescription
                        return
                    } else {
                        // Account deleted.
                        print("Account deleted")
                        let ref = Database.database().reference(fromURL: "https://oneway-500ad.firebaseio.com/").child("drivers").child((self.driver?.uid)!)
                        ref.removeValue(completionBlock: { (error, ref) in
                            if let error = error {
                                self.errorLabel.text = error.localizedDescription
                                return
                            }
                            let imgRef = Storage.storage().reference(forURL: "gs://oneway-500ad.appspot.com/").child("drivers").child((self.driver?.uid)!)
                            imgRef.delete(completion: { (error) in
                                if let error = error {
                                    self.errorLabel.text = error.localizedDescription
                                    return
                                }
                                self.errorLabel.text = ""
                                print("data deleted !!")
                                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                                self.present(loginViewController!, animated: true, completion: nil)
                            })
                        })
                    }
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    //delegate protocol function
    func passingModel(model: Model) {
        self.driver = model
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toEmail" {
            let emailVC = segue.destination as? ChangeEmail
            emailVC?.model = self.driver
            emailVC?.myDelegate = self
        }
        else if segue.identifier == "toName" {
            let nameVC = segue.destination as? ChangeName
            nameVC?.model = self.driver
            nameVC?.myDelegate = self
        }
        else if segue.identifier == "toPhone" {
            let phoneVC = segue.destination as? ChangePhone
            phoneVC?.model = self.driver
        }
        else if segue.identifier == "toPassword" {
            let passVc = segue.destination as? ChangePassword
            passVc?.model = self.driver
        }
    }

}
