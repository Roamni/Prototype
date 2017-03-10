//
//  KeyboardHideExtension.swift
//  Roamni
//
//  Created by Zihao Wang on 9/2/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import ReachabilitySwift
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alertBn(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
            self.alertBn(title: "No Internet Connection", message:  "Make sure your device is connected to the internet.")
        }
    }
    


    
}
