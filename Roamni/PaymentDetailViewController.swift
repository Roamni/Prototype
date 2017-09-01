//
//  PaymentDetailViewController.swift
//  Roamni
//
//  Created by Hyman Li on 10/8/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
class PaymentDetailViewController: UIViewController {

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var bsbField: UITextField!
    @IBOutlet weak var acctField: UITextField!
    @IBOutlet weak var abnField: UITextField!
    var ref:FIRDatabaseReference?
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        cancel.tintColor = UIColor.white
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
                dismiss(animated: true, completion: nil)
    }


    @IBAction func checkbox(_ sender: Any) {
        if self.checkBtn.currentImage == UIImage(named: "checkboxno"){
            self.checkBtn.setImage(UIImage(named: "checkboxyes"), for: .normal)
        }else{
            self.checkBtn.setImage(UIImage(named: "checkboxno"), for: .normal)
        }
    }

    @IBAction func save(_ sender: Any) {
        if self.nameField.text == nil || self.acctField.text == nil || self.bsbField.text == nil || self.nameField.text == nil || self.checkBtn.currentImage == UIImage(named: "checkboxno")
        {
            self.alertBn(title: "Error", message: "please input all field")
        }else{
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            self.ref?.child("paymentDetail").childByAutoId().setValue(["bankName":self.nameField.text,"bsb":self.bsbField.text,"acct":self.acctField.text,"abn":self.abnField.text,"uploadUser":uid])
            dismiss(animated: true, completion: nil)
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
