//
//  SetupRegController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 11/15/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase


class SetupRegController: UIViewController {

    
    var phoneText = ""
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    
    @IBOutlet weak var choosePhotoLabel: UILabel!
    
    @IBOutlet weak var endBtn: UIButton!
    
    let profileImageView = UIImageView()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        profileImageView.image = UIImage(named: "profile")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImageView.isUserInteractionEnabled = true
        
        view.addSubview(profileImageView)
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: choosePhotoLabel.bottomAnchor, constant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 275).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
       
        
    }
    

    
    
    @IBAction func endBtnFunc(_ sender: Any) {
        handleRegister()
        self.performSegue(withIdentifier: "FinishRegControllerSegue", sender: self)
    }
    

}
