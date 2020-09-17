//
//  UserCell.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/17/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase

class ContactCell: UITableViewCell {
    
    
    let profileImageView = UIImageView()
    let profileImageView2 = UIButton()
    
    
    var link: ContactsControllerNew?
    var message: Message? {
        didSet {
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: profileImageView.frame.maxX + 17, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: profileImageView.frame.maxX + 17, y: detailTextLabel!.frame.origin.y - 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = .lightGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        createContactCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error!")
    }
    /*
    @objc func handleMarkAsFavorite() {
        link?.someMethoWantToCall(cell: self)
    }
    */
    func createContactCell(){
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 28
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        profileImageView2.translatesAutoresizingMaskIntoConstraints = false
        profileImageView2.contentMode = .scaleAspectFill
        profileImageView2.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        profileImageView2.setImage(UIImage(named: "ic_right_arrow"), for: .normal)
        profileImageView2.tintColor = .lightGray
        //profileImageView2.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        
        addSubview(profileImageView2)
        
        profileImageView2.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -21).isActive = true
        profileImageView2.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView2.widthAnchor.constraint(equalToConstant: 12).isActive = true
        profileImageView2.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
}
