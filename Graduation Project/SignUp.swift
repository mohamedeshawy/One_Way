//
//  SignUp.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 2/12/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit

class SignUp: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let font = UIFont.systemFont(ofSize: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func segmentedControl(_ sender: Any) {
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
