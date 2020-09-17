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

class ContactsControllerNew: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let cellid = "cellid"
    var users = [User]()
    let tableView = UITableView()
    var newContactEmail: String?
    var newContactEmails = [String]()
    var contactEmails = [String]()
    var namesArray = [Contact]()
    var contactArray = [Contact]()
    var array = [String]()
    //let searchBar = UISearchBar()
    var searchResult = [User]()
    let searchController = UISearchController()
    
    
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
    
    func someMethoWantToCall(cell: UITableViewCell) {
        let indexPathTapped = tableView.indexPath(for: cell)
        let contact = namesArray[indexPathTapped!.row]
        let hasFavorited = contact.hasFavorited
        namesArray[indexPathTapped!.row].hasFavorited = !hasFavorited
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("favorites").child(uid).child(namesArray[indexPathTapped!.row].phoneNumber)
        
        
        
        var values = ["favorite" : "\(namesArray[indexPathTapped!.row].hasFavorited)"] as [String : Any]
        
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
        }
        
        tableView.reloadRows(at: [indexPathTapped!], with: .fade)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Добавить в избранное") {  (contextualAction, view, boolValue) in
            
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            let ref = Database.database().reference().child("favorites").child(uid).child((self.namesArray[indexPath.row].phoneNumber))
            
            
            
            var values = ["number" : "\(self.namesArray[indexPath.row].phoneNumber)"] as [String : Any]
            
            ref.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
            let alert = UIAlertController(title: "Избранное", message: NSLocalizedString("Контакт был успешно добавлен в избранное!", comment: ""), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OК", style: .default, handler: nil ))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        
        
        return swipeActions
    }
    
    
    @objc func addContact() {
        let alert = UIAlertController(title: NSLocalizedString("Добавить контакт", comment: ""), message: NSLocalizedString("Введите e-mail пользователя", comment: ""), preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Прим: test@gmail.com", comment: "")
        }
        alert.addAction(UIAlertAction(title: "OК", style: .default, handler: { [weak alert] (_) in
            if alert?.textFields![0] != nil {
                let textField = alert?.textFields![0]
                if self.newContactEmails.contains(textField!.text!) {
                    let message = NSLocalizedString("Контакт уже есть в вашей базе!", comment: "")
                    let innerAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    innerAlert.addAction(UIAlertAction(title: "OК", style: .default, handler:nil))
                    self.present(innerAlert, animated: true, completion: nil)
                } else {
                    if textField!.text != Auth.auth().currentUser?.phoneNumber {
                        if self.contactEmails.contains(textField!.text!) == false {
                            let message = NSLocalizedString("Такого пользователя не существует!", comment: "")
                            let innerAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                            innerAlert.addAction(UIAlertAction(title: "OК", style: .default, handler:nil))
                            self.present(innerAlert, animated: true, completion: nil)
                        } 
                        self.newContactEmail = textField!.text
                        self.users.removeAll()
                        self.sendMessageWithProperties()
                        let message = NSLocalizedString("Контакт успешно добавлен!", comment: "")
                        let innerAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        innerAlert.addAction(UIAlertAction(title: "OК", style: .default, handler:nil))
                        self.present(innerAlert, animated: true, completion: nil)
                    } else {
                        let message = NSLocalizedString("Нельзя добавить себя в контакты!", comment: "")
                        let innerAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        innerAlert.addAction(UIAlertAction(title: "OК", style: .default, handler:nil))
                        self.present(innerAlert, animated: true, completion: nil)
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        fetchEmails()
        fetchUsers()
        fetchFavorites()
        setupContactsController()
        
        
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
    }
    
    func setupContactsController() {
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
        
        let navigationItem = UINavigationItem()
        navigationBar.setItems([navigationItem], animated: false)
        navigationItem.title = NSLocalizedString("Контакты", comment: "")
        
        
        let image2 =  UIImage(named: "man")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(handleNewMessages))
        let image = UIImage(named: "user-2" )
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addContact))
        
        view.addSubview(searchController.searchBar)
        
        tableView.separatorInset = .init(top: 0, left: 65, bottom: 0, right: 20)
        tableView.frame = CGRect(x: 0, y: 105, width: self.view.frame.width, height: self.view.frame.height)
        tableView.backgroundColor = UIColor(named: "backgrn")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellid)
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        view.addSubview(tableView)
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
                                self.newContactEmails.append(newContactEmail)
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
    
    func fetchEmails() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = User()
                    let email = value["email"] as? String ?? "Email not found"
                    user.email = email
                    self.contactEmails.append(user.email!)
                }
            }
        }
    }
    
    func fetchFavorites() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let rootRef = Database.database().reference()
        let query = rootRef.child("favorites").child(uid).queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = User()
                    let email = value["favorite"] as? String ?? "Email not found"
                    user.email = email
                    self.array.append(user.email!)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! ContactCell
        let user = (searchController.isActive) ? searchResult[indexPath.row] : users[indexPath.row]
        var favorite = String()
        if array.count - 1 == indexPath.row {
            favorite = array[indexPath.row]
        }
        cell.link = self
        cell.detailTextLabel?.text = user.email
        cell.textLabel?.text = user.name
        
        var hasFavorite = Bool()
        if favorite == "false" {
            hasFavorite = false
        } else if favorite == "true" {
            hasFavorite = true
        }
        
        namesArray.append(Contact(name: user.name!, hasFavorited: hasFavorite, phoneNumber: cell.detailTextLabel!.text! ))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.profileImageView.image = UIImage(named: "profile")
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            
        }
        
        cell.profileImageView.layer.cornerRadius = 20
        cell.profileImageView.clipsToBounds = true
        cell.profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cell.profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        cell.backgroundColor = UIColor(named: "backgrn")
        
        var contact = namesArray[indexPath.row]
        cell.profileImageView2.imageView?.image = contact.hasFavorited ? UIImage(named:"starOn") : UIImage(named:"starOff")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    @objc func handleNewMessages() {
        
    }
    
    private func sendMessageWithProperties() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("addNewContact").child(uid)
        let childRef = ref.childByAutoId()
        var values = ["newUserEmail": newContactEmail] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
        }
    }
    
}
