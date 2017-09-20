//
//  MyRoamniSigninViewController.swift
//  Roamni
//
//  Created by Hyman Li on 19/9/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class MyRoamniSigninViewController: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!

    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        cancelBtn.tintColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
