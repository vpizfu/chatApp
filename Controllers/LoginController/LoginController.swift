//
//  LoginController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/3/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class LoginController: UIViewController {
    
    let passTextField = UITextField()
    let phoneTextField = UITextField()
    let nameTextField = UITextField()
    let loginRegisterButton = UIButton(type: .system)
     let codeButton = UIButton(type: .system)
    let inputsContainerView = UIView()
    lazy var profileImageView = UIImageView()
    let activityIndicatorView = UIActivityIndicatorView(style: .large )
    let ourNewView = UIView()
    
    //let sc = UISegmentedControl(items: [NSLocalizedString("Login", comment: ""), NSLocalizedString("Registration", comment: "")])
    
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor:NSLayoutConstraint?
    var phoneTextFieldHeightAnchor:NSLayoutConstraint?
    var passwordTextFieldHeightAnchor:NSLayoutConstraint?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        self.setupToHideKeyboardOnTapOnView()
        
        self.view.backgroundColor = UIColor(named: "backgrn")
        
        
        let color = UIColor.lightGray
        
        // MARK: profileImageView
        
        
        profileImageView.image = UIImage(named: "123.png")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        //profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImageView.isUserInteractionEnabled = true
        
        
        
        // MARK: nameTextField
        
        nameTextField.placeholder = NSLocalizedString("Name", comment: "")
        nameTextField.textColor = color
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: nameTextField.frame.height))
               nameTextField.leftViewMode = .always
        nameTextField.attributedPlaceholder = NSAttributedString(string: nameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
         
        nameTextField.layer.cornerRadius = 12
        // MARK: nameSeparatorView
       
        
        
        phoneTextField.placeholder = "Phone number"
        phoneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: phoneTextField.frame.height))
        phoneTextField.leftViewMode = .always
        phoneTextField.textColor = color
        phoneTextField.attributedPlaceholder = NSAttributedString(string: phoneTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.autocapitalizationType = .none
        phoneTextField.layer.cornerRadius = 12
        
        // MARK: phoneSeparatorView
        
       
        
        passTextField.placeholder = "Enter code"
        
        passTextField.textColor = color
        passTextField.isEnabled = false
        passTextField.isHidden = true
        
        passTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: passTextField.frame.height))
               passTextField.leftViewMode = .always
        passTextField.attributedPlaceholder = NSAttributedString(string: passTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        passTextField.layer.cornerRadius = 12
        //passTextField.isSecureTextEntry = true
        
        
        
        // MARK: inputsContainerView
        
        
        inputsContainerView.backgroundColor = .white
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.layer.cornerRadius = 12
        inputsContainerView.layer.masksToBounds = true
        view.addSubview(inputsContainerView)
        
        
        // MARK: addSubView
        
        inputsContainerView.addSubview(nameTextField)
        
        inputsContainerView.addSubview(phoneTextField)
   
        view.addSubview(profileImageView)
        
        // MARK: Anchors
        
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -45).isActive = true
        inputContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 35)
        inputContainerViewHeightAnchor?.isActive = true
        
        
        
        
        phoneTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        phoneTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        phoneTextFieldHeightAnchor = phoneTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor)
        phoneTextFieldHeightAnchor?.isActive = true
        
        nameTextField.backgroundColor = .white
        view.addSubview(nameTextField)
        
        nameTextField.leftAnchor.constraint(equalTo: phoneTextField.leftAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 35)
        nameTextFieldHeightAnchor?.isActive = true
        
        view.addSubview(passTextField)
        
        passTextField.leftAnchor.constraint(equalTo: phoneTextField.leftAnchor).isActive = true
        passTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12).isActive = true
        passTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -90).isActive = true
        passTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: phoneTextField.topAnchor, constant: -25).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
       
        
        
        // MARK: registerButton
        
        
        loginRegisterButton.backgroundColor = UIColor(named: "searchBar")
        loginRegisterButton.setTitle("Login", for: .normal)
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterButton.setTitleColor(UIColor.white, for: .normal)
        loginRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        view.addSubview(loginRegisterButton)
        
        
        codeButton.backgroundColor = UIColor(named: "searchBar")
        codeButton.setTitle("Confirm", for: .normal)
        codeButton.translatesAutoresizingMaskIntoConstraints = false
        codeButton.setTitleColor(UIColor.white, for: .normal)
        codeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        codeButton.addTarget(self, action: #selector(codeButtonRegister), for: .touchUpInside)
        codeButton.layer.cornerRadius = 12
        view.addSubview(codeButton)
        
        codeButton.leftAnchor.constraint(equalTo: passTextField.rightAnchor,constant: 12).isActive = true
        codeButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12).isActive = true
        codeButton.widthAnchor.constraint(equalToConstant: 78).isActive = true
        codeButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        codeButton.isHidden = true
        
        
        
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 77).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        ourNewView.backgroundColor = .clear
        
        
        ourNewView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ourNewView)

               
               ourNewView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                      ourNewView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                      ourNewView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                      ourNewView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        ourNewView.addSubview(activityIndicatorView)
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
               activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
               activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
               activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
               
        
        
    }
    
    
    
    @objc func codeButtonRegister() {
       
                activityIndicatorView.startAnimating()
                guard let otpCode = passTextField.text else {return}
                
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
                    } else {
                    
                   
                    
                    print(Auth.auth().currentUser!.uid)
                    let viewController = CustomTabBar()
                    viewController.modalPresentationStyle = .fullScreen
                    
                    self.present(viewController, animated: true, completion: nil)
                }
        }
    }
        
    

    
   
    
    @objc func handleLoginRegister() {
        self.ourNewView.isHidden = false
        self.activityIndicatorView.startAnimating()
        handleLogin()
        
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
            
            self.ourNewView.isHidden = true
            self.activityIndicatorView.stopAnimating()
            self.passTextField.isEnabled = true
            self.phoneTextField.isEnabled = false
            self.nameTextField.isEnabled = false
            self.passTextField.isHidden = false
            self.codeButton.isHidden = false
            self.loginRegisterButton.isHidden = true
            self.passTextField.backgroundColor = .white
            }
        }
        
        
        
    }
    
        
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
}

extension UIColor {
    
    convenience init (r: CGFloat, g: CGFloat, b:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

