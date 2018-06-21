//
//  Settings.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 6/20/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//
import UIKit
import SDWebImage

class Settings: UITableViewController {
    var driver : Model?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let driver=self.driver else {
            print("the driver is nil")
            return
        }
        print(driver.name)
        let url = URL(string: driver.photoUrl!)
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "img") )
        name.text = driver.name
        email.text = driver.email
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
            performSegue(withIdentifier: "toPicture", sender: self)
            
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
