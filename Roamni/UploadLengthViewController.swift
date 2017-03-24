//
//  UploadLengthViewController.swift
//  Roamni
//
//  Created by Zihao Wang on 24/3/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class UploadLengthViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var lengthPicker: UIPickerView!
    
    @IBAction func cancelBn(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }

    var pickString:String = "15"
    
    let categoryPickerValues = ["15","30","45","60","75","90","105","120","135","150","165","180","195","210","225","240"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerValues[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickString = categoryPickerValues[row]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
