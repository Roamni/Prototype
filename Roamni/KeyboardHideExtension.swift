//
//  KeyboardHideExtension.swift
//  Roamni
//
//  Created by Zihao Wang on 9/2/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
