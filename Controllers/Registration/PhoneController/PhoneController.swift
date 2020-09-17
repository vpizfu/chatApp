//
//  PhoneController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 11/15/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase


class PhoneController: UIViewController {

    var phoneText = ""
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
    
    @IBAction func phoneCodeButtonFunc(_ sender: Any) {
        phoneText = phoneTextField.text!
               handleLogin()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? CodeController {
            detailViewController.phoneText = self.phoneText
        }
    }
    
    func handleLogin() {
           guard let phoneNumber = phoneTextField.text else {return}
           
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                let alert = UIAlertController(title: NSLocalizedString("Ошибка!", comment: ""), message: "Не удалось пройти проверку, попробуйте еще раз!", preferredStyle: UIAlertController.Style.alert)
                
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
             
            print(Auth.auth().currentUser?.uid)
             self.performSegue(withIdentifier: "CodeControllerSegue", sender: self)
            }
        }
        
        
        
    }
    
    
     
}
