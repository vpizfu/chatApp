//
//  Extensions.swift
//  chatApp
//
//  Created by Roman Kharchenko on 10/16/19.
//  Copyright © 2019 Roman Kharchenko. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    
    func loadImageUsingCacheWithUrlString(urlString:String) {
        self.image = UIImage(named: "profile")
        
        if let cachedImage = imageCache.object(forKey:urlString as AnyObject) {
            
            self.image = cachedImage as? UIImage
            return
        } 
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }

            }
        }).resume()
    }
    
    func loadImageUsingCacheWithUrlString2(urlString:String) {
        
        self.backgroundColor = UIColor(named: "backgrn")
        
        if let cachedImage = imageCache.object(forKey:urlString as AnyObject) {
            self.image = cachedImage as? UIImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            }
        }).resume()
    }
}


