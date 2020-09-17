//
//  CodeController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 11/15/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase

class CodeController: UIViewController {

   
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    
    var phoneText = ""
    
    var uidArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("hello")
       print(phoneText)
        print("hello")
        
        fetchUids()
    }
    

   
    @IBAction func codeButtonFunc(_ sender: Any) {
          codeButtonRegister()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? SetupRegController {
            detailViewController.phoneText = self.phoneText
        }
    }
    
    @objc func codeButtonRegister() {
          
        
                   
                   guard let otpCode = codeTextField.text else {return}
                   
                   let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                   
                   let credential = PhoneAuthProvider.provider().credential(
                       withVerificationID: verificationID!,
                       verificationCode: otpCode)
                   
                   Auth.auth().signIn(with: credential) { (user, error) in
                       if error != nil {
                           let alert = UIAlertController(title: NSLocalizedString("Ошибка!", comment: ""), message: "Неверный проверочный код!", preferredStyle: UIAlertController.Style.alert)
                           
                           
                           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                               
                           }))
                           
                           self.present(alert, animated: true, completion: nil)
                        print("1")
                        print (error)
                        print("1")
                       } else {
                        
                        self.checkAuth()
                   }
           }
       }
    
    func fetchUids() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let uid = value["uid"] as? String ?? "Number not found"
                    self.uidArray.append(uid)
                    
                }
            }
        }
    }
    
    func checkAuth() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        print("1")
        print(uidArray[0])
        print("1")
        if self.uidArray.contains(uid) {
            self.performSegue(withIdentifier: "FinishAuthControllerSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "SetupRegControllerSegue", sender: self)
        }
    }
}
