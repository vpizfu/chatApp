//
//  FinishRegController.swift
//  
//
//  Created by Roman Kharchenko on 11/15/19.
//

import UIKit
import Firebase

class FinishRegController: UIViewController {


    
    
    let button = UIButton()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        button.backgroundColor = UIColor(named: "searchBar2-1")
        button.setTitle("Начать пользоваться DARO", for: .normal)
        button.setTitleColor(UIColor(named: "Color-5"), for: .normal)
        button.addTarget(self, action: #selector(goToTabBar)
            , for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 23
        
        let x = view.frame.maxX / 2 - 130
        let y = view.frame.maxY - 150
        button.frame = CGRect(x: x, y: y, width: 260, height: 46)
        
            
        view.addSubview(button)

        
        
    }
    
    
    @objc func goToTabBar() {
       
        print(Auth.auth().currentUser?.uid)
        let viewController = CustomTabBar()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
       
    }
    
    

}
