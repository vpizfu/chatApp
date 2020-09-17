//
//  ChatLogController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/16/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import AVKit

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var player: AVAudioPlayer?
    var userEmail = String()
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            userEmail = user!.email!
            observerMessages()
            
            
            
        }
    }
    
    let containerView = UIView()
    
    let inputTextField = UITextField()
    
    var messages = [Message]()
    
    var players:ChatMessageCell?
    
    func playSound(name:String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

           
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            
            guard let player = player else { return }

            player.play()
            print("123")

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func observerMessages() {
        guard let uid = Auth.auth().currentUser?.uid,let toId = user?.id else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        
        
        
        userMessagesRef.observe(.childAdded) { (snapshot) in
            
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String:AnyObject] else {
                    
                    return
                }
                
               
               let message = Message(dictionary: dictionary)
                
                
                
                
              
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        
                        
                        self.collectionView.reloadData()
                        
                        /*
                        if message.fromId == uid {
                            self.playSound(name: "send")
                        } else {
                            self.playSound(name: "recieve")
                        }
                        */
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                
                
                
                
                
                
                
                
            }
            
        }
    }
    
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        setupToHideKeyboardOnTapOnView()
        textFieldShouldReturn(inputTextField)
        
        let image2 = UIImage(named: "video")
        let image3 = UIImage(named: "telephone-3")
        
        
        let videoButton   = UIBarButtonItem(image: image2,  style: .plain, target: self, action: #selector(videoCall))
        let audioButton = UIBarButtonItem(image: image3,  style: .plain, target: self, action:#selector(audioCall))

        
        videoButton.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        navigationItem.rightBarButtonItems = [audioButton, videoButton]
        
        let image = UIImage(named: "left-arrow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .plain, target: self, action: #selector(goBackFnc))
       
        navigationController?.navigationBar.barTintColor = UIColor(named: "backgrn")
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = UIColor(named: "backgrn")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsSelection = true
        
        setupInputComponents()
        
        setupKeyboardObservers()
        
        }
    
    
    
    func setupKeyboardObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
       
       
    }
    
    
    
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
        
    }
    
    
    @objc func handleKeyboardWillHide(notification:NSNotification) {
        
     
        
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    @objc func handleKeyboardWillShow(notification:NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            as! ChatMessageCell
        
        cell.chatLogController = self
        
        let message = messages[indexPath.item]
        
        cell.message = message
        
        cell.textView.text = message.text
        
       // let hello = Int(message.timestamp!)
        
        //cell.timeView.text = String(hello)
        
        
        
        cell.backgroundColor = UIColor(named: "backgrn")
        setupCell(cell: cell, message: message)
        
        if message.videoUrl == nil {
               cell.playButton.isHidden = true
               } else {
                   cell.playButton.isHidden = false
               }
        
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.textView.isHidden = false
        } else if cell.playButton.isHidden == false {
             cell.messageImageView.isUserInteractionEnabled = false
            cell.bubbleWidthAnchor?.constant = self.view.frame.width / 2
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = self.view.frame.width / 2
            cell.textView.isHidden = true
        }
        
       
        
        //cell.playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        
        
        return cell
        
    }
    
   

  
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
        let message = messages[indexPath.item]
        print("123")
       
         if message.videoUrl != nil {
           
            if let videoUrlString = message.videoUrl, let url = URL(string: videoUrlString) {
                   
                       let player = AVPlayer(url: url)
                       let playerController = AVPlayerViewController()
                
                playerController.player = player
                
                self.present(playerController, animated: true) {
                    playerController.player!.play()
                }
  
                       
                   }
        }
    }
    
    
    
    
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor(named:"bubbleText")
            cell.textView.textColor = UIColor(named:"bubbleColor")
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = UIColor(named:"bubbleText")
            cell.textView.textColor = UIColor(named:"bubbleColor")
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.backgroundColor = UIColor.clear
            cell.messageImageView.loadImageUsingCacheWithUrlString2(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            
        } else {
            cell.messageImageView.isHidden = true
           
            
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 20
        } else if message.imageUrl != nil {
            let imageWidth = message.imageWidth?.floatValue
            let imageHeight = message.imageHeight?.floatValue
            height = CGFloat(imageHeight! / imageWidth! * 200)
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text:String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size , options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    @objc func goBackFnc() {
        let viewController = CustomTabBar()
        viewController.modalPresentationStyle = .fullScreen
        
        
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc func videoCall() {
       //if let facetimeURL:NSURL = NSURL(string: "facetime://\(userEmail)")
        if let facetimeURL:NSURL = NSURL(string: "facetime://\(userEmail)")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(facetimeURL as URL)) {
                application.open(facetimeURL as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func audioCall() {
       //if let facetimeURL:NSURL = NSURL(string: "facetime-audio://\(userEmail)")
        if let facetimeURL:NSURL = NSURL(string: "facetime-audio://\(userEmail)")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(facetimeURL as URL)) {
                application.open(facetimeURL as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    let profileImageView = UIImageView()
    let profileImageView2 = UIImageView()
    func setupInputComponents() {
   
        containerView.backgroundColor = UIColor(named: "backgrn")
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Введите сообщение", comment: ""),
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 13.0)])
        
        inputTextField.setLeftPaddingPoints(18)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        inputTextField.layer.cornerRadius = 19
        inputTextField.layer.masksToBounds = true
        inputTextField.contentMode = .scaleAspectFill
        inputTextField.backgroundColor = UIColor(named: "searchBar")
        inputTextField.textColor = .white 
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 65).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -80).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -12).isActive = true
        
        
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(named: "microphone")
        
        containerView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: inputTextField.rightAnchor, constant: 15).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 11).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 11).isActive = true
        
        profileImageView2.translatesAutoresizingMaskIntoConstraints = false
        profileImageView2.contentMode = .scaleAspectFill
        profileImageView2.image = UIImage(named: "photo-camera")
        
        containerView.addSubview(profileImageView2)
        
        profileImageView2.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        profileImageView2.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView2.widthAnchor.constraint(equalToConstant: 14).isActive = true
        profileImageView2.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        
        
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(named: "icons8-plus-24"), for: .normal)
        sendButton.backgroundColor = UIColor(named: "searchBar4")
        sendButton.layer.cornerRadius = 12.5
        sendButton.layer.masksToBounds = true
        sendButton.contentMode = .scaleAspectFill
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.isUserInteractionEnabled = true
        sendButton.addTarget(self, action: #selector(handleUploadTap), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20 ).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 25 ).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 25 ).isActive = true
        
        
        
       
        
       
       
        
    
        
      
        
      
    }
    
    @objc func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        
        //imagePickerController.allowsEditing = true
        
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        
        present(imagePickerController,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            handleVideoSelectedForUrl(url: videoUrl)
            
            dismiss(animated: true, completion: nil)
        } else {
            handleImageSelectedForInfo(info: info)
        }
        
       
    }
        
    
    
    
    func handleVideoSelectedForUrl(url: URL){

        let someFileName = NSUUID().uuidString + ".mov"
        let data = NSData(contentsOf: url)
        var strPic = String()
        var strPic2 = url
        var uploadedVideoUrl = String()
        
        
        
        let storageRef = Storage.storage().reference().child("Videos").child(someFileName)
        
        if let uploadData = data as Data? {
            
           let a = storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                   
                    if let error = error {
                        
                    }else{
                        
                        
                        
                        storageRef.downloadURL(completion: { (storageURL, error) in

                           if let error = error {

                               print("error getting the uploaded video from storage")

                               print(error.localizedDescription)

                               return

                           }

                            uploadedVideoUrl = storageURL!.absoluteString
                        
                            
                            strPic = uploadedVideoUrl
                         
                            strPic2 = storageURL!
                             
                        
                    })
                       
                    if let thumbnailImage = self.thumbnailImageForFileURL(fileUrl: strPic2) {
                    self.uploadToFirebaseStorageUsingImage(image: thumbnailImage) { (imageUrl) in
                        let values = ["imageUrl": imageUrl,"imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height, "videoUrl": uploadedVideoUrl as Any] as [String : Any]
                        
                        self.sendMessageWithProperties(properties: values)
                        }
                    }
                }
            })
            a.observe(.progress) { (snapshot) in
                let percentComplete = Int(100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount))
                if let completedUnitCount = snapshot.progress?.completedUnitCount {
                    self.navigationItem.title = String(percentComplete) + "%"
                }
            }
            
            a.observe(.success) { (snapshot) in
                self.navigationItem.title = self.user?.name
            }
        }
        
    }
    
    
    private func thumbnailImageForFileURL(fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGeneratot = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGeneratot.copyCGImage(at: CMTimeMake(value: 1,timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err{
            print(err)
        }
        return nil
    }
    

private func handleImageSelectedForInfo(info: [UIImagePickerController.InfoKey : Any]) {
    var selectedImageFromPicker: UIImage?
    if let editedImage = info[.editedImage] as? UIImage {
        selectedImageFromPicker = editedImage
    } else if let originalImage = info[.originalImage] as? UIImage {
        selectedImageFromPicker = originalImage
    }
    
    if let selectedImage = selectedImageFromPicker {
        self.uploadToFirebaseStorageUsingImage(image: selectedImage, completion: { (imageUrl) in
            self.sendMessagesWithUrl(imageUrl: imageUrl, image: selectedImage)
            
        })
    }
        self.dismiss(animated: true, completion: nil)
}
    private func uploadToFirebaseStorageUsingImage(image: UIImage, completion: @escaping (_ imageUrl: String) -> ()){ // Sending images to Firebase
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child("\(imageName).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.1){
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print("Failed to upload image:", error as Any)
                    return
                }
                print(ref.downloadURL(completion: { (url, err) in
                    if err != nil{
                        print(err as Any)
                        return
                    }
                    else{
                        let imageUrl = url?.absoluteString
                        print(imageUrl)
                        completion(imageUrl!)
                        //self.sendMessagesWithUrl(imageUrl: imageUrl!, image: image)
                    }
                }))
            })
        }
    }
    
    private func sendMessagesWithUrl(imageUrl: String, image: UIImage) {
        
        
            
            
            
            
            
        let properties = ["imageUrl":imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height ] as [String : Any]
        sendMessageWithProperties(properties: properties)
            
    }
    
    private func sendMessageWithProperties(properties:[String:Any]) {
        
        
        
            let ref = Database.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            let toId = user!.id!
            
            
            
            let fromId = Auth.auth().currentUser!.uid
            let timestamp = NSDate().timeIntervalSince1970
            var values = ["toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
        properties.forEach({values[$0] = $1})
        
        
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                self.inputTextField.text = nil
                guard let messageId = childRef.key else { return }
                
                
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(messageId)
                userMessagesRef.setValue(1)
                
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId).child(messageId)
                recipientUserMessagesRef.setValue(1)
            
                
            
        }
        
        
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSend() {
        if inputTextField.text != "" {
            
            let properties = ["text":inputTextField.text!] as [String : Any]
            sendMessageWithProperties(properties: properties)
            }
            
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            handleSend()
        textField.returnKeyType = UIReturnKeyType.send
        self.view.endEditing(true)
        //self.scrollToBottom()
            return true
    }
    
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView:UIView?
    
    var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleZoomOut))
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
      
        self.inputTextField.resignFirstResponder()
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleZoomOut))
        zoomingImageView.addGestureRecognizer(tapGesture)
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                self.containerView.alpha = 0
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                print(self.startingFrame!.height)
                print(self.startingFrame!.width)
                print(height)
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }) { (completed) in
            }
        }
    }
    
    @objc func handleZoomOut(sender:UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.containerView.alpha = 1
            }) { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            }
            
            
            
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

