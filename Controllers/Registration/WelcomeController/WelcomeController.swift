//
//  WelcomeController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 11/15/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase

class WelcomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnFuncContinue(_ sender: Any) {
        performSegue(withIdentifier: "PhoneControllerSegue", sender: self)
    }
}
