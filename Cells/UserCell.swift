//
//  UserCell.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/17/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let timeLabel = UILabel()
    
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            if message?.text != nil {
                self.detailTextLabel?.text = message?.text
            } else {
                self.detailTextLabel?.text = "Фото"
            }
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "hh:mm a"
                timeLabel.text = dateFormat.string(from: timestampDate as Date)
            }
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
        
        setupTimeLabelAndProfileImageView()
        
    }
    
    func setupTimeLabelAndProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 28
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        timeLabel.font = timeLabel.font.withSize(13)
        timeLabel.textColor = UIColor(named:"bubbleColor")
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(timeLabel)
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    func setupNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {
            
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
                
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error!")
    }
    
}
