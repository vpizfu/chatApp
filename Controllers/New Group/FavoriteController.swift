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

class FavoriteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellid = "cellid"
    var users = [User]()
    var phoneNumbers = [String]()
    var globalNewUserEmail = String()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        setupFavoriteControllerView()
        fetchFavorites()
        fetchUsers()
    }
    
    func setupFavoriteControllerView() {
        view.backgroundColor = UIColor(named: "backgrn")
        
        let width = view.frame.width
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 38, width: width, height: 50))
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.addSubview(navigationBar)
        let navigationItem = UINavigationItem()
        navigationBar.setItems([navigationItem], animated: false)
        navigationItem.title = ("Избранное")
        let image2 =  UIImage(named: "left-arrow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(goBack))
        tableView.separatorInset = .init(top: 0, left: 65, bottom: 0, right: 20)
        tableView.frame = CGRect(x: 0, y: 88, width: view.frame.width, height: view.frame.height)
        tableView.backgroundColor = UIColor(named: "backgrn")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CallsCell.self, forCellReuseIdentifier: cellid)
        tableView.allowsSelection = false
        view.addSubview(tableView)
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
                    let email = value["number"] as? String ?? "Number not found"
                    user.email = email
                    self.phoneNumbers.append(user.email!)
                }
            }
        }
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
                    
                    if self.phoneNumbers.contains(email) {
                        user.name = name
                        user.email = email
                        user.profileImageUrl = profileImageUrl
                        self.users.append(user)
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! CallsCell
        let user = users[indexPath.row]
        cell.detailTextLabel?.text = user.email
        cell.textLabel?.text = user.name
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
    
    @objc func goBack() {
        dismiss(animated: true) {
        }
    }
    
}
