//
//  Extensions.swift
//  melbourne1
//
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    
    func loadImageUsingCacheWithUrlString(urlString: String)
    {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as?
            UIImage
        {
            self.image = cachedImage
            return
            
        }
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL,completionHandler: {(data,response,error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadeImage = UIImage(data: data!)
                {
                    imageCache.setObject(downloadeImage, forKey: urlString as AnyObject)
                    self.image = downloadeImage
                }
            }
            
        }).resume()
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
