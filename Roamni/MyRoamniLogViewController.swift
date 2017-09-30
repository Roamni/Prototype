//
//  MyRoamniLogViewController.swift
//  Roamni
//
//  Created by Hyman Li on 15/9/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
class MyRoamniLogViewController: UIViewController {
    

    @IBOutlet weak var loginBn: FBSDKLoginButton!

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let loginButton = FBSDKLoginButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        //loginButton.delegate = self
        //print("loglog")
        self.hideKeyboardWhenTappedAround()
        self.loginBn.readPermissions =  ["public_profile","email"]
        self.loginBn.delegate = self
        

       
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        //login()
        loginBn.applyDesign()
        logggin()
    }
    
    func logggin(){
        print("facebookfacebook")
        if let user = FIRAuth.auth()?.currentUser{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: testViewController = storyboard.instantiateViewController(withIdentifier: "firstView") as! testViewController
            
            self.present(vc, animated: true, completion: nil)
            //var modalVC = storyboard.instantiateViewController(withIdentifier: "firstView") as? testViewController
            //modalVC?.modalPresentationStyle = .overFullScreen
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(_ sender: Any) {
        if self.emailField.text == "" || self.passwordField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "firstView")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
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
extension MyRoamniLogViewController:FBSDKLoginButtonDelegate{
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try!FIRAuth.auth()?.signOut()
        print("log out of facebook")
        //self.tableView.reloadData()
        //super.viewDidLoad()
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil{
            print(error)
            print("loglogerror")
            return
        }
        else if result.isCancelled {
            // Handle cancellations
            return
        }
        else{
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                if let error = error {
                    print(error)
                    print("loglogeeeeeerrrrr")
                    return
                }
                //self.tableView.reloadData()
                //super.viewDidLoad()
                
            }
            print("successfully logged in ")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: testViewController = storyboard.instantiateViewController(withIdentifier: "firstView") as! testViewController
            
            self.present(vc, animated: true, completion: nil)

        }
    }
    
}
extension FBSDKLoginButton{
    func applyDesign(){
        self.backgroundColor = UIColor.darkGray
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset =  CGSize(width:0,height:0)
    }
}

class roundButton : UIButton{
    override func didMoveToWindow() {
        self.backgroundColor = UIColor.darkGray
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset =  CGSize(width:0,height:0)
    }
}

