//
//  SignUp.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 2/12/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignUp: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var re_passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    let imagePicker = UIImagePickerController()
     var model : Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.imageView.addGestureRecognizer(gesture)
        
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        // do other task
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func register(_ sender: Any) {
        guard let email = emailTextField.text , let password = re_passwordTextField.text,let name = nameTextField.text,let phone = phoneTextField.text  else {
            print("the form not valid !")
            return
        }
        if name == ""{
            self.errorLabel.text = "*name is required"
        }
        else if email == ""{
            self.errorLabel.text = "*email is required"
        }
        else if passwordTextField.text == ""{
            self.errorLabel.text = "*password is required"
        }
        else if passwordTextField.text != password{
            self.errorLabel.text = "password is not matched"
        }
        else if phone == "" {
            self.errorLabel.text = "*phone is required"
        }
        else {
            Auth.auth().createUser(withEmail: email, password: password, completion: {
                (user,error) in
                if let error=error{
                    self.errorLabel.text = error.localizedDescription
                    return
                }
                guard let uid=user?.uid else {
                    return
                }
                guard let image=self.imageView.image else{
                    return
                }
                self.errorLabel.text = ""   
                let ref = Database.database().reference(fromURL: "https://oneway-500ad.firebaseio.com/")
                let imgRef = Storage.storage().reference(forURL: "gs://oneway-500ad.appspot.com/")
                if let ImageData = UIImageJPEGRepresentation(image, 0.8){
                    let driverImageRef = imgRef.child("drivers").child(uid+"/UserImage.jpg")
                    driverImageRef.putData(ImageData, metadata: nil, completion: {
                        (metaData,error) in
                        if let error = error {
                            print (error.localizedDescription)
                            return
                        }
                        else {
                            let downloadURL = metaData!.downloadURL()!.absoluteString
                            let driverReference = ref.child("drivers").child(uid)
                            let data = ["Name" : name, "Email":email, "Password" : password, "Phone_Number" : phone, "downloadURL": downloadURL]
                            driverReference.updateChildValues(data)
                            print("success signup as driver")
                            self.model = Model(uid: uid, name: name, email: email, phone: phone, photoUrl: downloadURL)
                            self.performSegue(withIdentifier: "driverFromSignUp", sender: self)
                        }
                    })
                }
            })
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let tabVC = segue.destination as? UITabBarController
        let driverVC = tabVC?.viewControllers?.first as? DriverMap
        driverVC?.driver = self.model
        let settingsVC = tabVC?.viewControllers?.last as? Settings
        settingsVC?.driver = self.model
    }

}
