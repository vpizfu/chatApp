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

class CallController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
    let cellid = "cellid"
    var users = [User]()
    
    let searchController = UISearchController()
     var globalNewUserEmail = String()
    var searchResult = [User]()
    
    let tableView = UITableView()
    
    func updateSearchResults(for searchController: UISearchController) {
       if let searchText = searchController.searchBar.text {
             filterContent(searchText: searchText)
            DispatchQueue.main.async { self.tableView.reloadData()
            }
         }
     }
     
     func filterContent(searchText: String) {
       searchResult = users.filter { (email: User) -> Bool in
           let emailMatch =  email.email?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
           let nameMatch = email.name?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
           return emailMatch != nil || nameMatch != nil
       }
     }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        
        self.view.backgroundColor = UIColor(named: "backgrn")
        
        let width = self.view.frame.width
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 38, width: width, height: 50))
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        self.view.addSubview(navigationBar)
        
        searchController.searchBar.placeholder = NSLocalizedString("Люди, группы и сообщения", comment: "")
               searchController.searchBar.barTintColor = UIColor(named: "searchBar")
               searchController.searchBar.layer.borderColor = UIColor.clear.cgColor
               searchController.searchBar.layer.borderWidth = 1
        
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        
               
        
        
        let navigationItem = UINavigationItem()
        navigationBar.setItems([navigationItem], animated: false)
        
        navigationItem.title = NSLocalizedString("Звонки", comment: "")
        
        
        let image2 =  UIImage(named: "man")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(handleNewMessage))
        
        let image = UIImage(named: "user-2" )
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        
        
        tableView.separatorInset = .init(top: 0, left: 65, bottom: 0, right: 20)
        tableView.frame = CGRect(x: 0, y: 105, width: self.view.frame.width, height: self.view.frame.height)
        tableView.backgroundColor = UIColor(named: "backgrn")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CallsCell.self, forCellReuseIdentifier: cellid)
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        fetchUsers()
        
    }
    
    @objc func handleCancel() {
        
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUserButton() {
        users.removeAll()
        fetchUsers()
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
                                    
                                   
                                    if self.users.contains(user) {
                                        print("User already added!")
                                    } else {
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
               return searchResult.count
               } else {
               return users.count
               }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! CallsCell
        
        
        
        let user = (searchController.isActive) ? searchResult[indexPath.row] : users[indexPath.row]
        
         
   
         
        
       
        
        
        
        cell.detailTextLabel?.text = user.email
        
        cell.textLabel?.text = user.name
        
        
        
        
        //audioCall(email: user.email!)
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.profileImageView.image = UIImage(named: "profile")
       
        if let profileImageUrl = user.profileImageUrl {
            
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            cell.profileImageView3.setImage(UIImage(named: "video"), for: .normal)
            cell.profileImageView2.setImage(UIImage(named: "telephone-3"), for: .normal)
           
        }
        
        cell.profileImageView.layer.cornerRadius = 20
        cell.profileImageView.clipsToBounds = true
        
        
     
        cell.profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cell.profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cell.textLabel?.frame = CGRect(x: cell.profileImageView.frame.maxX + 20, y: cell.textLabel!.frame.origin.y, width: cell.textLabel!.frame.width, height: cell.textLabel!.frame.height)
        
        
        cell.backgroundColor = UIColor(named: "backgrn")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    
    
    
    
    
    
    
    
    @objc func handleNewMessage2() {
        let newMessageController = ViewController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController,animated: true,completion: nil)
        
    
    }
    
    @objc func handleNewMessage() {
    
    }
    
    @objc func showChatController(user: User) {
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        let navController = UINavigationController(rootViewController: chatLogController)
        navController.modalPresentationStyle = .fullScreen
        present(navController,animated: true,completion: nil)
        
        
    }
    
    
}
