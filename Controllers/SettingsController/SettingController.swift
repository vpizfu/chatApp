//
//  SettingController.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/21/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit
import Firebase

class SettingController: UIViewController {
    
let containerView = UIView()
    
  
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
        
        
        let navigationItem = UINavigationItem()
        navigationBar.setItems([navigationItem], animated: false)
        
        navigationItem.title = NSLocalizedString("Настройки", comment: "")
        
        
        let image2 =  UIImage(named: "man")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(handleNewMessage))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Изм.", comment: ""), style: .plain, target: self, action: #selector(handleNewMessage))
      
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "searchBar4")
        
        containerView.backgroundColor = UIColor(named: "backgrn")
        containerView.frame = CGRect(x: 0, y: 88, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(containerView)
         
        let containerWidth = self.containerView.frame.width - 50
        
        createButton6(title: NSLocalizedString("Уведомление и звуки", comment: ""), y: 120, imageName: "ic_notifications", width: Int(containerWidth), left: 45)
        createButton3(title: NSLocalizedString("Конфидециальность", comment: ""), y: 160, imageName: "ic_padlock", width: Int(containerWidth), left: 45)
       
        createButton3(title: NSLocalizedString("Данные и память" , comment: ""), y: 200, imageName: "ic_database", width: Int(containerWidth), left: 45)
        createButton4(title: NSLocalizedString("Оформление", comment: ""), y: 240, imageName: "ic_edit", width: Int(containerWidth), left: 45)
        createButton5(title:NSLocalizedString("Язык", comment: ""), y: 280, imageName: "ic_language", width: Int(containerWidth), left: 45)
        createButton6(title: NSLocalizedString("Избранное", comment: ""), y: 40, imageName: "ic_favorite", width: Int(containerWidth), left: 45)
        createButton7(title:  NSLocalizedString("Помощь", comment: ""), y: 360, imageName: "ic_help", width: Int(containerWidth), left: 45)
        createButton8(title:  NSLocalizedString("Вопросы о DARO", comment: ""), y: 400, imageName: "ic_questions", width: Int(containerWidth), left: 45)
        
        

        
        
        
        
        
    }
    
    @objc func handleNewMessage() {
        
    }
    
    @objc func clearCache() {
        let alert = UIAlertController(title: "Данные и память", message: "Вы уверены, что хотите очистить кэш?!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Очистить", style: UIAlertAction.Style.cancel , handler: { [weak alert, weak self] (_) in
        let message = "Кэш был успешно удалён!"
        let innerAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        innerAlert.addAction(UIAlertAction(title: "Oк", style: .default, handler:nil))
            self!.present(innerAlert, animated: true, completion: nil)
        
            
    }))
        self.present(alert, animated: true, completion: nil)
}
    
   
     let imagiView = UIImageView()

    func createButton(title:String, y: Int, imageName:String, width: Int, left:Int) {
        
        
        /*
       
        let imagiView2 = UIImageView()
        let imagiView3 = UIImageView()
        let questioButton = UIButton()
        
        questioButton.contentHorizontalAlignment = .left
        questioButton.backgroundColor = UIColor(named: "searchBar0")
        questioButton.frame = CGRect(x:25, y: y, width: width, height: 36)
        questioButton.layer.cornerRadius = 9
        questioButton.setTitle(title, for: .normal)
        questioButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
       questioButton.setTitleColor(UIColor(named:"textColor"), for: .normal)
        questioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(left), bottom: 0, right: 0)
        questioButton.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        containerView.addSubview(questioButton)
        
        
        
        
        imagiView.backgroundColor = UIColor(named: "searchBar2")
        imagiView.layer.cornerRadius = 5
        imagiView.frame = CGRect(x: 10, y: 7, width: 22, height: 22)
        questioButton.addSubview(imagiView)
        
        imagiView2.image = UIImage(named:imageName)
        imagiView2.frame = CGRect(x: 6, y: 6, width: 10, height: 10)
        imagiView.addSubview(imagiView2)
        
        imagiView3.image = UIImage(named: "ic_right_arrow")
        imagiView3.frame = CGRect(x: width - 25, y: 11, width: 14, height: 14)
        questioButton.addSubview(imagiView3)
    }
    
    func createButton2(title:String, y: Int, imageName:String, width: Int, left:Int) {
        
        
        
        let imagiView = UIImageView()
        let imagiView2 = UIImageView()
        let imagiView3 = UIImageView()
        let questioButton = UIButton()
        
        questioButton.contentHorizontalAlignment = .left
        questioButton.backgroundColor = UIColor(named: "searchBar0")
        questioButton.frame = CGRect(x:25, y: y, width: width, height: 36)
        questioButton.layer.cornerRadius = 9
        questioButton.setTitle(title, for: .normal)
        questioButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
       questioButton.setTitleColor(UIColor(named:"textColor"), for: .normal)
        questioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(left), bottom: 0, right: 0)
        questioButton.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        containerView.addSubview(questioButton)
        
        
        
        
        imagiView.backgroundColor = UIColor(named: "searchBar2")
        imagiView.layer.cornerRadius = 5
        imagiView.frame = CGRect(x: 10, y: 7, width: 22, height: 22)
        questioButton.addSubview(imagiView)
        
        imagiView2.image = UIImage(named:imageName)
        imagiView2.frame = CGRect(x: 6, y: 6, width: 10, height: 10)
        imagiView.addSubview(imagiView2)
        
        imagiView3.image = UIImage(named: "ic_right_arrow")
        imagiView3.frame = CGRect(x: width - 25, y: 11, width: 14, height: 14)
        questioButton.addSubview(imagiView3)
 */
        
        
            
            
            
             

        
    }
    
    func createButton3(title:String, y: Int, imageName:String, width: Int, left:Int) {
        
        
        
        let imagiView = UIImageView()
        let imagiView2 = UIImageView()
        let imagiView3 = UIImageView()
        let questioButton = UIButton()
        
        questioButton.contentHorizontalAlignment = .left
        questioButton.backgroundColor = UIColor(named: "searchBar0")
        questioButton.frame = CGRect(x:25, y: y, width: width, height: 36)
        questioButton.layer.cornerRadius = 9
        questioButton.setTitle(title, for: .normal)
        questioButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    questioButton.setTitleColor(UIColor(named:"textColor"), for: .normal)
        questioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(left), bottom: 0, right: 0)
        questioButton.addTarget(self, action: #selector(clearCache), for: .touchUpInside)
        containerView.addSubview(questioButton)
        
        
        
        
        imagiView.backgroundColor = UIColor(named: "searchBar2")
        imagiView.layer.cornerRadius = 5
        imagiView.frame = CGRect(x: 10, y: 7, width: 22, height: 22)
        questioButton.addSubview(imagiView)
        
        imagiView2.image = UIImage(named:imageName)
        imagiView2.frame = CGRect(x: 6, y: 6, width: 10, height: 10)
        imagiView.addSubview(imagiView2)
        
        imagiView3.image = UIImage(named: "ic_right_arrow")
        imagiView3.frame = CGRect(x: width - 25, y: 11, width: 14, height: 14)
        questioButton.addSubview(imagiView3)
    }
    
    func createButton4(title:String, y: Int, imageName:String, width: Int, left:Int) {
        
        
       
        let imagiView = UIImageView()
        let imagiView2 = UIImageView()
        let imagiView3 = UIImageView()
        let questioButton = UIButton()
        
        questioButton.contentHorizontalAlignment = .left
        questioButton.backgroundColor = UIColor(named: "searchBar0")
        questioButton.frame = CGRect(x:25, y: y, width: width, height: 36)
        questioButton.layer.cornerRadius = 9
        questioButton.setTitle(title, for: .normal)
        questioButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
      questioButton.setTitleColor(UIColor(named:"textColor"), for: .normal)
        questioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(left), bottom: 0, right: 0)
        questioButton.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        containerView.addSubview(questioButton)
        
        
        
        
        imagiView.backgroundColor = UIColor(named: "searchBar2")
        imagiView.layer.cornerRadius = 5
        imagiView.frame = CGRect(x: 10, y: 7, width: 22, height: 22)
        questioButton.addSubview(imagiView)
        
        imagiView2.image = UIImage(named:imageName)
        imagiView2.frame = CGRect(x: 6, y: 6, width: 10, height: 10)
        imagiView.addSubview(imagiView2)
        
        imagiView3.image = UIImage(named: "ic_right_arrow")
        imagiView3.frame = CGRect(x: width - 25, y: 11, width: 14, height: 14)
        questioButton.addSubview(imagiView3)
    }
    
    func createButton5(title:String, y: Int, imageName:String, width: Int, left:Int) {
        
        
        
        let imagiView = UIImageView()
        let imagiView2 = UIImageView()
        let imagiView3 = UIImageView()
        let questioButton = UIButton()
        
        questioButton.contentHorizontalAlignment = .left
        questioButton.backgroundColor = UIColor(named: "searchBar0")
        questioButton.frame = CGRect(x:25, y: y, width: width, height: 36)
        questioButton.layer.cornerRadius = 9
        questioButton.setTitle(title, for: .normal)
        questioButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
       questioButton.setTitleColor(UIColor(named:"textColor"), for: .normal)
        questioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(left), bottom: 0, right: 0)
        questioButton.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        containerView.addSubview(questioButton)
        
        
        
        
        imagiView.backgroundColor = UIColor(named: "searchBar2")
        imagiView.layer.cornerRadius = 5
        imagiView.frame = CGRect(x: 10, y: 7, width: 22, height: 22)
        questioButton.addSubview(imagiView)
        
        imagiView2.image = UIImage(named:imageName)
        imagiView2.frame = CGRect(x: 6, y: 6, width: 10, height: 10)
        imagiView.addSubview(imagiView2)
        
        imagiView3.image = UIImage(named: "ic_right_arrow")
        imagiView3.frame = CGRect(x: width - 25, y: 11, width: 14, height: 14)
        questioButton.addSubview(imagiView3)
    }
    
    func createButton6(title:String, y: Int, imageName:String, width: Int, left:Int) {
        
        
        
        let imagiView = UIImageView()
        let imagiView2 = UIImageView()
        let imagiView3 = UIImageView()
        let questioButton = UIButton()
        
        questioButton.contentHorizontalAlignment = .left
        questioButton.backgroundColor = UIColor(named: "searchBar0")
        questioButton.frame = CGRect(x:25, y: y, width: width, height: 36)
        questioButton.layer.cornerRadius = 9
        questioButton.setTitle(title, for: .normal)
        questioButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        questioButton.setTitleColor(UIColor(named:"textColor"), for: .normal)
        questioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(left), bottom: 0, right: 0)
        questioButton.addTarget(self, action: #selector(hadleLogout), for: .touchUpInside)
        containerView.addSubview(questioButton)
        
        
        
        
        imagiView.backgroundColor = UIColor(named: "searchBar2")
        imagiView.layer.cornerRadius = 5
        imagiView.frame = CGRect(x: 10, y: 7, width: 22, height: 22)
        questioButton.addSubview(imagiView)
        
        imagiView2.image = UIImage(named:imageName)
        imagiView2.frame = CGRect(x: 6, y: 6, width: 10, height: 10)
        imagiView.addSubview(imagiView2)
        
        imagiView3.image = UIImage(named: "ic_right_arrow")
        imagiView3.frame = CGRect(x: width - 25, y: 11, width: 14, height: 14)
        questioButton.addSubview(imagiView3)
    }
    
    
    
    @objc func logoutFnc() {
        performSegue(withIdentifier: "WelcomeRegSegue2", sender: self)
    }
    
    //MARK: hadleLogout()
    
    @objc func hadleLogout() {
        do {
            try Auth.auth().signOut()
         
        } catch let logoutError {
            print ( logoutError )
        }
        
        logoutFnc()
    }
    
    
        @objc func allFavorites() {
            let favorite = FavoriteController()
            present(favorite, animated: true, completion: nil)
    }
   
 
    
    func createButton7(title:String, y: Int, imageName:String, width: Int, left:Int) {
        
        
       
        let imagiView = UIImageView()
        let imagiView2 = UIImageView()
        let imagiView3 = UIImageView()
        let questioButton = UIButton()
        
        questioButton.contentHorizontalAlignment = .left
        questioButton.backgroundColor = UIColor(named: "searchBar0")
        questioButton.frame = CGRect(x:25, y: y, width: width, height: 36)
        questioButton.layer.cornerRadius = 9
        questioButton.setTitle(title, for: .normal)
        questioButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        questioButton.setTitleColor(UIColor(named:"textColor"), for: .normal)
        questioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(left), bottom: 0, right: 0)
        questioButton.addTarget(self, action: #selector(goOnHelpWebSite), for: .touchUpInside)
        containerView.addSubview(questioButton)
        
        
        
        
        imagiView.backgroundColor = UIColor(named: "searchBar2")
        imagiView.layer.cornerRadius = 5
        imagiView.frame = CGRect(x: 10, y: 7, width: 22, height: 22)
        questioButton.addSubview(imagiView)
        
        imagiView2.image = UIImage(named:imageName)
        imagiView2.frame = CGRect(x: 6, y: 6, width: 10, height: 10)
        imagiView.addSubview(imagiView2)
        
        imagiView3.image = UIImage(named: "ic_right_arrow")
        imagiView3.frame = CGRect(x: width - 25, y: 11, width: 14, height: 14)
        questioButton.addSubview(imagiView3)
    }
    
    @objc func goOnHelpWebSite() {
        UIApplication.shared.openURL(URL(string: "https://vk.com/someguyishere")!)
    }
    
    func createButton8(title:String, y: Int, imageName:String, width: Int, left:Int) {
        
        
        
        let imagiView = UIImageView()
        let imagiView2 = UIImageView()
        let imagiView3 = UIImageView()
        let questioButton = UIButton()
        
        questioButton.contentHorizontalAlignment = .left
        questioButton.backgroundColor = UIColor(named: "searchBar0")
        questioButton.frame = CGRect(x:25, y: y, width: width, height: 36)
        questioButton.layer.cornerRadius = 9
        questioButton.setTitle(title, for: .normal)
        questioButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        questioButton.setTitleColor(UIColor(named:"textColor"), for: .normal)
        questioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(left), bottom: 0, right: 0)
        questioButton.addTarget(self, action: #selector(goOnHelpWebSite), for: .touchUpInside)
        containerView.addSubview(questioButton)

        imagiView.backgroundColor = UIColor(named: "searchBar2")
        imagiView.layer.cornerRadius = 5
        imagiView.frame = CGRect(x: 10, y: 7, width: 22, height: 22)
        questioButton.addSubview(imagiView)
        
        imagiView2.image = UIImage(named:imageName)
        imagiView2.frame = CGRect(x: 6, y: 6, width: 10, height: 10)
        imagiView.addSubview(imagiView2)
        
        imagiView3.image = UIImage(named: "ic_right_arrow")
        imagiView3.frame = CGRect(x: width - 25, y: 11, width: 14, height: 14)
        questioButton.addSubview(imagiView3)
    }








}
