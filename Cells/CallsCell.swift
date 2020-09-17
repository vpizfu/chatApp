//
//  UserCell.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/17/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase

class CallsCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let profileImageView2 = UIButton()
    let profileImageView3 = UIButton()
    let timeLabel = UILabel()
    
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            if message?.text != nil {
                self.detailTextLabel?.text = message?.text
            } else {
                self.detailTextLabel?.text = NSLocalizedString("Фото", comment: "")
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
        setupCallCell()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("Error!")
    }
    
    
    
    func setupCallCell() {
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
        
        
        profileImageView2.addTarget(self, action: #selector(audioCall), for: .touchUpInside)
        
        addSubview(profileImageView2)
        
        profileImageView2.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        profileImageView2.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView2.widthAnchor.constraint(equalToConstant: 21).isActive = true
        profileImageView2.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        
        profileImageView3.translatesAutoresizingMaskIntoConstraints = false
        profileImageView3.contentMode = .scaleAspectFill
        profileImageView3.addTarget(self, action: #selector(videoCall), for: .touchUpInside)
        
        addSubview(profileImageView3)
        
        profileImageView3.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -55).isActive = true
        profileImageView3.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView3.widthAnchor.constraint(equalToConstant: 25).isActive = true
        profileImageView3.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        timeLabel.font = timeLabel.font.withSize(13)
        timeLabel.textColor = UIColor.lightGray
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
    
    @objc func videoCall() {
        if let facetimeURL:NSURL = NSURL(string: "facetime://\(detailTextLabel!.text!)")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(facetimeURL as URL)) {
                application.open(facetimeURL as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func audioCall() {
        if let facetimeURL:NSURL = NSURL(string: "facetime-audio://\(detailTextLabel!.text!)")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(facetimeURL as URL)) {
                application.open(facetimeURL as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
}
