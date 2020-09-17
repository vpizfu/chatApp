//
//  ViewController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/3/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    let cellReuseIdentifier = "cellid"
    let tableView = UITableView()
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = UIColor(named: "backgrn")
        

        setupToHideKeyboardOnTapOnView()
       
        createNavBar()
        
        
        self.tableView.register(UserCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        tableView.frame = CGRect(x: 0, y: 150, width: width, height: height)
        tableView.backgroundColor = UIColor(named: "backgrn")
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        
         
        
    }
    
   
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = self.messages[indexPath.row]
        if let chatPartnerId = message.chatPartnerId(){
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
                print(chatPartnerId)
                if error != nil {
                    print("error")
                    return
                }
                
                
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                 self.handleReloadTable()
                
            }
            
        }
        
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let userId = snapshot.key
            
            
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                
                self.fetchMessageWithMessageId(messageId: messageId)
            
            }, withCancel: nil)
            
            
            
            
          
        }
        
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.handleReloadTable()
        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        let messageReference = Database.database().reference().child("messages").child(messageId)
                              
                              messageReference.observeSingleEvent(of: .value) { (snapshot) in
                                   if let dictionary = snapshot.value as? [String:AnyObject] {
                                                 let message = Message(dictionary: dictionary)
                                                
                                                 
                                                 if let chatPartnerId = message.chatPartnerId() {
                                                     self.messagesDictionary[chatPartnerId] = message
                                                     
                                                     
                                                 }
                                                 
                                    self.attemptReloadOfTable()
                                                               
                                                 
                                                 
                                             }
                              }
    }
    
    func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer:Timer?
    
    @objc func handleReloadTable() {
        
        self.messages = Array(self.messagesDictionary.values)
        
        self.messages.sort { (m1, m2) -> Bool in
            return m1.timestamp!.intValue > m2.timestamp!.intValue
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellid")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        
        cell.message = message
        cell.backgroundColor = UIColor(named: "backgrn")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            

            let user = User()
            
            user.email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
            user.name = (snapshot.value as? NSDictionary)?["name"] as? String ?? ""
            user.profileImageUrl = (snapshot.value as? NSDictionary)?["profileImageUrl"] as? String ?? ""
            user.id = chatPartnerId
            
            
            self.showChatController(user: user)
           
            }
           
    }
        
    
    
    
    //MARK: createNavBar()
    
     
    let navigationItems = UINavigationItem()
    
    func createNavBar() {
        
       
        reload()
        
        
        let width = self.view.frame.width
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 38, width: width, height: 50))
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        self.view.addSubview(navigationBar)
        
        /*
        let searchView = UIView()
        searchView.frame = CGRect(x: 0, y: 105, width: width, height: 30)
        searchView.backgroundColor = UIColor(named: "searchBar")
        
        view.addSubview(searchView)
        
        */
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 105, width: width, height: 45)
        searchBar.placeholder = NSLocalizedString("Люди, группы и сообщения", comment: "")
        searchBar.barTintColor = UIColor(named: "searchBar")
        
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.layer.borderWidth = 1
      
        
        view.addSubview(searchBar)

        
        navigationBar.setItems([navigationItems], animated: false)
        
        
        let image2 =  UIImage(named: "man")
        navigationItems.leftBarButtonItem = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(handleNewMessages))
        
        let image = UIImage(named: "edit" )
        navigationItems.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
       
        
         let titleView = UIView()
         titleView.center = navigationBar.center
         
        
         
         let profileImageView = UIImageView()
         profileImageView.translatesAutoresizingMaskIntoConstraints = false
         profileImageView.contentMode = .scaleAspectFill
        
         profileImageView.clipsToBounds = true
         
          
         profileImageView.image = UIImage(named: "settings")
         
         
         
         titleView.addSubview(profileImageView)
        
         
         profileImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
         profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor,constant: -40).isActive = true
         profileImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
         profileImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
    
         self.navigationItem.titleView = titleView
        
         
        // titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        
        
         navigationBar.addSubview(titleView)
    }
    
    @objc func changeProfileImage() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker,animated:true,completion:nil)
    }
    
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
            
        }
        
        if let selectedImage = selectedImageFromPicker {
            navigationItems.leftBarButtonItem?.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    //MARK: handleNewMessage()
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController,animated: true,completion: nil)
        
        
    }
    
    @objc func handleNewMessages() {
         
           
       }
    
    
    
    
    
    //MARK: checkIfUserIsLoggedIn()
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(hadleLogout), with: nil, afterDelay:0)
            
            
        } else {
            
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                    
                    
                
                    
                }
                
            }, withCancel: nil)
            
        }
    }
    
    func reload() {
        messages.removeAll()
        messagesDictionary.removeAll()
        
        self.tableView.reloadData()
        
        
        
        observeUserMessages()
    }
    
   
    
    @objc func showChatController(user: User) {
     
           let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
           chatLogController.user = user
           let navController = UINavigationController(rootViewController: chatLogController)
           navController.modalPresentationStyle = .fullScreen
           present(navController,animated: true,completion: nil)
           
        
       }
    
    //MARK: logoutFnc()
    
    @objc func logoutFnc() {
        let loginController = WelcomeController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
        
        
         

    }
    
    //MARK: hadleLogout()
    
    @objc func hadleLogout() {
        do {
            try Auth.auth().signOut()
             print ( "hello" )
        } catch let logoutError {
            print ( "hello2" )
        }
        
        logoutFnc()
    }
    
    
    
}





