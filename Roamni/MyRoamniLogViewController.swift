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

    let loginButton = FBSDKLoginButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        //loginButton.delegate = self
        //print("loglog")
        self.loginBn.readPermissions =  ["public_profile","email"]
        self.loginBn.delegate = self
       
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        login()
    }
    
    func login(){
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
