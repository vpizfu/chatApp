    //
    //  LoginController+handlers.swift
    //  chatApp
    //
    //  Created by Roman Kharchenko on 10/13/19.
    //  Copyright © 2019 Roman Kharchenko. All rights reserved.
    //
    
    import UIKit
    import Firebase
    import FirebaseDatabase
    
    extension SetupRegController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func handleRegister() {
            
            
            
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_Images").child("\(imageName).jpg")
            
           
            
            if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
                
                
                
                
                /*if let uploadData = self.profileImageView.image!.pngData()
                 */
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata,error) in
                    if error != nil {
                        print ("error")
                        return
                    }
                    
                    
                    
                    storageRef.downloadURL { url, error in
                        if error != nil {
                            print("error")
                        } else {
                            let imageUrl = url!.absoluteString
                            let values = ["name":self.nameTextField.text!, "email":self.phoneText,"profileImageUrl":imageUrl, "uid": uid]
                            
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                            
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                })
            }
            
            
            
            
            
            
            
            
        }
        
        
        
        
        private func registerUserIntoDatabaseWithUID(uid:String, values:[String:String]) {
            
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            
            
            let usersReference = ref.child("users").child(uid)
            
            
            
            
         
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err,ref) in
                
                if err != nil {
                  
                    return
                }
                
                
                
            })
        }
        
        @objc func handleSelectProfileImageView() {
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
                profileImageView.image = selectedImage
            }
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
