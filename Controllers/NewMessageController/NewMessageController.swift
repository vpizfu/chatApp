//
//  NewMessageControllerTableViewController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/5/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewMessageController: UITableViewController {
    
    let cellid = "cellid"
    var users = [User]()
    
    
    
    var globalNewUserEmail = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "searchBar")
        navigationController?.navigationBar.barTintColor = UIColor(named: "backgrn")
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        tableView.backgroundColor = UIColor(named: "backgrn")
       
        fetchUsers()
        
    }
    
    @objc func handleCancel() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
  
    
    
    func fetchUsers() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let user = User()
                    
                    user.id = (((child as AnyObject).key) as String)
                    let name = value["name"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    let profileImageUrl = value["profileImageUrl"] as? String ?? "Image not found"
                    
                    
                    
                    user.name = name
                    user.email = email
                    user.profileImageUrl = profileImageUrl
                    
                    
                    let rootRef2 = Database.database().reference()
                    
                    guard let uid = Auth.auth().currentUser?.uid else {
                        return
                    }
                    
                    let query2 = rootRef2.child("addNewContact").child(uid).queryOrdered(byChild: "newUserEmail")
                    
                    query2.observe(.value) { (snapshot) in
                        for child in snapshot.children.allObjects as! [DataSnapshot] {
                            if let value = child.value as? NSDictionary {
                                
                                let newContactEmail = value["newUserEmail"] as? String ?? "New user email not found"
                                
                                user.newUserEmail = newContactEmail
                                
                                
                                
                                if user.newUserEmail == user.email {
                                    self.users.append(user)
                                    DispatchQueue.main.async { self.tableView.reloadData()
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.profileImageView.image = UIImage(named: "profile")
        if let profileImageUrl = user.profileImageUrl {
            
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        cell.backgroundColor = UIColor(named: "backgrn")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: ViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            print(user)
            self.messagesController?.showChatController(user: user)
            
        }
    }
    
    
}
