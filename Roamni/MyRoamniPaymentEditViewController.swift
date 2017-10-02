//
//  MyRoamniPaymentEditViewController.swift
//  Roamni
//
//  Created by Hyman Li on 28/9/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
class MyRoamniPaymentEditViewController: UIViewController {
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var bsbField: UITextField!
    @IBOutlet weak var acctField: UITextField!
    @IBOutlet weak var abnField: UITextField!
    var ref:FIRDatabaseReference?
    var downloadPayments = [PaymentDetail]()
    var downloadPayment:PaymentDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.ref = FIRDatabase.database().reference()
        fetchTours()
        // Do any additional setup after loading the view.
    }

    @IBAction func checkbox(_ sender: Any) {
        if self.checkBtn.currentImage == UIImage(named: "checkboxno"){
            self.checkBtn.setImage(UIImage(named: "checkboxyes"), for: .normal)
        }else{
            self.checkBtn.setImage(UIImage(named: "checkboxno"), for: .normal)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        if self.nameField.text == nil || self.acctField.text == nil || self.bsbField.text == nil || self.nameField.text == nil || self.checkBtn.currentImage == UIImage(named: "checkboxno")
        {
            self.alertBn(title: "Error", message: "please input all field")
        }else{
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            if self.downloadPayment != nil{
            let abnRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("paymentDetail/\(downloadPayment!.detailId)/abn")
            let nameRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("paymentDetail/\(downloadPayment!.detailId)/bankName")
            let acctRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("paymentDetail/\(downloadPayment!.detailId)/acct")
            let uploadUserRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("paymentDetail/\(downloadPayment!.detailId)/uploadUser")
            let bsbRef = FIRDatabase.database().reference(fromURL: "https://romin-ff29a.firebaseio.com/").child("paymentDetail/\(downloadPayment!.detailId)/bsb")
            
                abnRef.setValue(self.abnField.text)
                nameRef.setValue(self.nameField.text)
                acctRef.setValue(self.acctField.text)
                uploadUserRef.setValue(uid)
                bsbRef.setValue(self.bsbField.text)
                
            }else{
                self.ref?.child("paymentDetail").childByAutoId().setValue(["bankName":self.nameField.text,"bsb":self.bsbField.text,"acct":self.acctField.text,"abn":self.abnField.text,"uploadUser":uid])
            }

            dismiss(animated: true, completion: nil)
        }

    }
    
    
    func fetchTours(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("paymentDetail").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            for child in result!{
                let dictionary = child.value as!  [String : Any]
                let downloadPayment = PaymentDetail(bsb: dictionary["bsb"] as! String, bankname: dictionary["bankName"] as! String, acct: dictionary["acct"] as! String, abn: dictionary["abn"] as! String,detailId:child.key, uploadUser: dictionary["uploadUser"] as! String)
               
                //print("aaaaaa\(dictionary["uploadUser"])")
                if let user = FIRAuth.auth()?.currentUser{
                  
                    let uid = user.uid
                    if  downloadPayment.uploadUser == uid
                    {
                        
                        self.downloadPayment = downloadPayment
                        //self.downloadPayments.append(downloadTour)
                        //print(self.downloadTours)
                        DispatchQueue.main.async(execute: { } )
                    }
                }
                else{
                    print("no permission")
                }
            }
        })
        
        
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
