//
//  CustomTabBarViewController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/31/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase

class CustomTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        setupTabBar()
    }
}
