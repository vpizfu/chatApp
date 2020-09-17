//
//  ChatMessageCell.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/18/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var message: Message?
    
    let textView = UITextView()
    let timeView = UITextView()
    let bubbleView = UIView()
    let profileImageView = UIImageView()
    let playButton = UIButton(type: .system)
    lazy var messageImageView = UIImageView()
    var bubbleWidthAnchor:NSLayoutConstraint?
    var bubbleHeightAnchor:NSLayoutConstraint?
    var bubbleViewRightAnchor:NSLayoutConstraint?
    var bubbleViewLeftAnchor:NSLayoutConstraint?
    var chatLogController: ChatLogController?
    var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap(_:)))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
         messageImageView.translatesAutoresizingMaskIntoConstraints = false
         messageImageView.layer.cornerRadius = 16
         messageImageView.layer.masksToBounds = true
         messageImageView.contentMode = .scaleAspectFill
         messageImageView.backgroundColor = .brown
         messageImageView.isUserInteractionEnabled = true
         tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap(_:)))
         messageImageView.addGestureRecognizer(tapGesture)
         
        
         playButton.translatesAutoresizingMaskIntoConstraints = false
         playButton.tintColor = .white
         playButton.setImage(UIImage(named:"playBtn2"), for: .normal)
         playButton.isUserInteractionEnabled = false

         textView.font = UIFont.systemFont(ofSize: 16)
         textView.translatesAutoresizingMaskIntoConstraints = false
         textView.backgroundColor = UIColor.clear
         textView.textColor = .white
         textView.isEditable = false
         textView.isUserInteractionEnabled = false
        
        timeView.font = UIFont.systemFont(ofSize: 5)
                timeView.translatesAutoresizingMaskIntoConstraints = false
                timeView.backgroundColor = UIColor.clear
                timeView.textColor = .black
                timeView.isEditable = false
                timeView.isUserInteractionEnabled = false

         bubbleView.backgroundColor = UIColor(r: 0, g: 137, b: 249)
         bubbleView.translatesAutoresizingMaskIntoConstraints = false
         bubbleView.layer.cornerRadius = 16
         bubbleView.layer.masksToBounds = true
         bubbleView.isUserInteractionEnabled = true

         profileImageView.translatesAutoresizingMaskIntoConstraints = false
         profileImageView.layer.cornerRadius = 16
         profileImageView.layer.masksToBounds = true
         profileImageView.contentMode = .scaleAspectFill
         profileImageView.isUserInteractionEnabled = true
         
         addSubview(bubbleView)
         addSubview(textView)
         addSubview(profileImageView)
        
         
         bubbleView.addSubview(messageImageView)

         profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
         profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
         profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
         profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
          
         bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
         bubbleViewRightAnchor?.isActive = true
         bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)

         bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
         bubbleWidthAnchor?.isActive = true
         bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
         bubbleHeightAnchor?.isActive = true
         
         textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
         textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
         textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
         textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
         
        
        
         messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
         messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
         messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
         messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
         
         bubbleView.addSubview(playButton)
         
         playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
         playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
         playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
         playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }

    @objc func handleZoomTap(_ sender: UITapGestureRecognizer) {
        
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
        self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
}


