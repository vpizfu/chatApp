//
//  CustomTabBarExtensions.swift
//  chatApp
//
//  Created by Roman Kharchenko on 11/20/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import Foundation
import Firebase

extension CustomTabBar {
    func setupTabBar() {
        tabBar.tintColor = UIColor(named: "searchBar2-1")
        tabBar.unselectedItemTintColor = .white
        tabBar.barTintColor = UIColor(named: "searchBar4-1")

        let mainVC = ViewController()
        mainVC.tabBarItem.title = NSLocalizedString("Чаты", comment: "")
        mainVC.tabBarItem.image = UIImage(named: "speech-bubble-19")
        
        let callsVC = CallController()
        callsVC.tabBarItem.title = NSLocalizedString("Звонки", comment: "")
        callsVC.tabBarItem.image = UIImage(named: "telephone-4")
        
        let contactsVC = ContactsControllerNew()
        contactsVC.tabBarItem.title = NSLocalizedString("Контакты", comment: "")
        contactsVC.tabBarItem.image = UIImage(named: "user-3")
        
        let settingsVC = SettingController()
        settingsVC.tabBarItem.title = NSLocalizedString("Настройки", comment: "")
        settingsVC.tabBarItem.image = UIImage(named: "settings-3")

        
        self.viewControllers = [mainVC, callsVC, contactsVC, settingsVC]
    }
    
    func checkIfUserIsLoggedIn() {
    if Auth.auth().currentUser?.uid == nil {
        perform(#selector(hadleLogout), with: nil, afterDelay:0)
        }
    }
    
    @objc func logoutFnc() {
        performSegue(withIdentifier: "WelcomeRegSegue", sender: self)
    }
    
    //MARK: hadleLogout()
    
    @objc func hadleLogout() {
        do {
            try Auth.auth().signOut()
         
        } catch let logoutError {
            print ( logoutError )
        }
        
        logoutFnc()
    }
}
