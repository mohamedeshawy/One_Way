//
//  Settings.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 4/19/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit

class Settings: UIViewController {
    var driver : Model?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                guard let driver=self.driver else {
                    print("the driver is nil")
                    return
                }
                print(driver.name)

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
