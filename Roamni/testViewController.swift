//
//  testViewController.swift
//  Roamni
//
//  Created by Zihao Wang on 28/3/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet weak var playView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   let tabcontroller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        self.addChildViewController(tabcontroller)
        self.view.addSubview(tabcontroller.view)
        self.view.addSubview(self.playView)
        tabcontroller.didMove(toParentViewController: self)
        
        // Do any additional setup after loading the view.
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
