//
//  ViewController.swift
//  Collectionview Horizontal Image
//
//  Created by Hyman Li on 7/3/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,ValueReturner {
    
    var returnValueToCaller: ((Any) -> ())?
    var returnValueToCaller1: ((Any) -> ())?
    var Fcontroller:SearchContainerViewController?
    var tours = [DownloadTour]()
    var tourCategory : String?
    
    @IBOutlet weak var textbox: UITextField!
    
    @IBOutlet weak var dropdown: UIPickerView!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    var durationTime:Int? = 90
    var tType:String? = "default"
    let step: Float = 15
    
    @IBAction func setTime(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        timeLabel.text = "\(String(Int(sender.value))) min"
        self.durationTime = Int(sender.value)
    }

    
    @IBAction func btn1(_ sender: Any) {
        btn1.setImage(UIImage(named: "11"), for: UIControlState.normal)
        btn2.setImage(UIImage(named: "2"), for: UIControlState.normal)
        btn3.setImage(UIImage(named: "3"), for: UIControlState.normal)
        btn4.setImage(UIImage(named: "4"), for: UIControlState.normal)
        btn5.setImage(UIImage(named: "5"), for: UIControlState.normal)
        btn6.setImage(UIImage(named: "6"), for: UIControlState.normal)
        btn7.setImage(UIImage(named: "7"), for: UIControlState.normal)
        btn8.setImage(UIImage(named: "8"), for: UIControlState.normal)
 //       btn9.setImage(UIImage(named: "9"), for: UIControlState.normal)
        tType = "Accessible"
        
    }

    @IBAction func btn2(_ sender: Any) {
        btn1.setImage(UIImage(named: "1"), for: UIControlState.normal)
        btn2.setImage(UIImage(named: "21"), for: UIControlState.normal)
        btn3.setImage(UIImage(named: "3"), for: UIControlState.normal)
        btn4.setImage(UIImage(named: "4"), for: UIControlState.normal)
        btn5.setImage(UIImage(named: "5"), for: UIControlState.normal)
        btn6.setImage(UIImage(named: "6"), for: UIControlState.normal)
        btn7.setImage(UIImage(named: "7"), for: UIControlState.normal)
        btn8.setImage(UIImage(named: "8"), for: UIControlState.normal)
     //   btn9.setImage(UIImage(named: "9"), for: UIControlState.normal)
        tType = "Shopping"

    }
    
    @IBAction func btn3(_ sender: Any) {
        btn1.setImage(UIImage(named: "1"), for: UIControlState.normal)
        btn2.setImage(UIImage(named: "2"), for: UIControlState.normal)
        btn3.setImage(UIImage(named: "31"), for: UIControlState.normal)
        btn4.setImage(UIImage(named: "4"), for: UIControlState.normal)
        btn5.setImage(UIImage(named: "5"), for: UIControlState.normal)
        btn6.setImage(UIImage(named: "6"), for: UIControlState.normal)
        btn7.setImage(UIImage(named: "7"), for: UIControlState.normal)
        btn8.setImage(UIImage(named: "8"), for: UIControlState.normal)
      //  btn9.setImage(UIImage(named: "9"), for: UIControlState.normal)
        tType = "Real Estate"
    }
    
    @IBAction func btn4(_ sender: Any) {
        btn1.setImage(UIImage(named: "1"), for: UIControlState.normal)
        btn2.setImage(UIImage(named: "2"), for: UIControlState.normal)
        btn3.setImage(UIImage(named: "3"), for: UIControlState.normal)
        btn4.setImage(UIImage(named: "41"), for: UIControlState.normal)
        btn5.setImage(UIImage(named: "5"), for: UIControlState.normal)
        btn6.setImage(UIImage(named: "6"), for: UIControlState.normal)
        btn7.setImage(UIImage(named: "7"), for: UIControlState.normal)
        btn8.setImage(UIImage(named: "8"), for: UIControlState.normal)
      //  btn9.setImage(UIImage(named: "9"), for: UIControlState.normal)
        tType = "Walking"
    }
    
    @IBAction func btn5(_ sender: Any) {
        btn1.setImage(UIImage(named: "1"), for: UIControlState.normal)
        btn2.setImage(UIImage(named: "2"), for: UIControlState.normal)
        btn3.setImage(UIImage(named: "3"), for: UIControlState.normal)
        btn4.setImage(UIImage(named: "4"), for: UIControlState.normal)
        btn5.setImage(UIImage(named: "51"), for: UIControlState.normal)
        btn6.setImage(UIImage(named: "6"), for: UIControlState.normal)
        btn7.setImage(UIImage(named: "7"), for: UIControlState.normal)
        btn8.setImage(UIImage(named: "8"), for: UIControlState.normal)
//        btn9.setImage(UIImage(named: "9"), for: UIControlState.normal)
        tType = "Cycling"
    }
    
    @IBAction func btn6(_ sender: Any) {
        btn1.setImage(UIImage(named: "1"), for: UIControlState.normal)
        btn2.setImage(UIImage(named: "2"), for: UIControlState.normal)
        btn3.setImage(UIImage(named: "3"), for: UIControlState.normal)
        btn4.setImage(UIImage(named: "4"), for: UIControlState.normal)
        btn5.setImage(UIImage(named: "5"), for: UIControlState.normal)
        btn6.setImage(UIImage(named: "61"), for: UIControlState.normal)
        btn7.setImage(UIImage(named: "7"), for: UIControlState.normal)
        btn8.setImage(UIImage(named: "8"), for: UIControlState.normal)
    //    btn9.setImage(UIImage(named: "9"), for: UIControlState.normal)
        tType = "Driving"
    }
    
    @IBAction func btn7(_ sender: Any) {
        btn1.setImage(UIImage(named: "1"), for: UIControlState.normal)
        btn2.setImage(UIImage(named: "2"), for: UIControlState.normal)
        btn3.setImage(UIImage(named: "3"), for: UIControlState.normal)
        btn4.setImage(UIImage(named: "4"), for: UIControlState.normal)
        btn5.setImage(UIImage(named: "5"), for: UIControlState.normal)
        btn6.setImage(UIImage(named: "6"), for: UIControlState.normal)
        btn7.setImage(UIImage(named: "71"), for: UIControlState.normal)
        btn8.setImage(UIImage(named: "8"), for: UIControlState.normal)
  //      btn9.setImage(UIImage(named: "9"), for: UIControlState.normal)

    }
    
    @IBAction func btn8(_ sender: Any) {
        btn1.setImage(UIImage(named: "1"), for: UIControlState.normal)
        btn2.setImage(UIImage(named: "2"), for: UIControlState.normal)
        btn3.setImage(UIImage(named: "3"), for: UIControlState.normal)
        btn4.setImage(UIImage(named: "4"), for: UIControlState.normal)
        btn5.setImage(UIImage(named: "5"), for: UIControlState.normal)
        btn6.setImage(UIImage(named: "6"), for: UIControlState.normal)
        btn7.setImage(UIImage(named: "7"), for: UIControlState.normal)
        btn8.setImage(UIImage(named: "81"), for: UIControlState.normal)
 //       btn9.setImage(UIImage(named: "9"), for: UIControlState.normal)

    }
    
    @IBAction func btn9(_ sender: Any) {
        btn1.setImage(UIImage(named: "1"), for: UIControlState.normal)
        btn2.setImage(UIImage(named: "2"), for: UIControlState.normal)
        btn3.setImage(UIImage(named: "3"), for: UIControlState.normal)
        btn4.setImage(UIImage(named: "4"), for: UIControlState.normal)
        btn5.setImage(UIImage(named: "5"), for: UIControlState.normal)
        btn6.setImage(UIImage(named: "6"), for: UIControlState.normal)
        btn7.setImage(UIImage(named: "7"), for: UIControlState.normal)
        btn8.setImage(UIImage(named: "8"), for: UIControlState.normal)
        
 //       btn9.setImage(UIImage(named: "91"), for: UIControlState.normal)

    }
    
    
    
    func sortForTours(this:DownloadTour, that:DownloadTour) -> Bool{
        return this.star > that.star
    }
    
    @IBAction func filterDone(_ sender: Any) {
        
        switch self.textbox.text! {
        case "Highest Rating":
            self.tours.sort(by: sortForTours)
            break
        case "Lowest Rating":
             self.tours.sort(by: { (this:DownloadTour, that:DownloadTour) -> Bool in
                return this.star < that.star
             })
            break

        case "Longest Time":
            self.tours.sort(by: { (this:DownloadTour, that:DownloadTour) -> Bool in
                return this.length > that.length
            })
            break

        case "Shortest Time":
            self.tours.sort(by: { (this:DownloadTour, that:DownloadTour) -> Bool in
                return this.length < that.length
            })
            break

        default:
            self.tours.sort(by: sortForTours)
        }
        
        var onetours = [DownloadTour]()
       
        if tType != "default"
        {
        for onetour in self.tours{
            if onetour.length <= self.durationTime! && onetour.tourType == tType{
                onetours.append(onetour)
            }
        }
        
        
        tours.removeAll()
        tours = onetours
        }
        else{
            for onetour in self.tours{
                if onetour.length <= self.durationTime!{
                    onetours.append(onetour)
                }
            }
            
            
            tours.removeAll()
            tours = onetours
        
        }
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if tType == "default"{
            tType = ""
        }
        delegate.tourCategory = tType
        //self.tourCategory = "Driving"
        returnValueToCaller?(self.tours)
        //print("tttttttttttttttttpppppppp\(self.tourCategory!)")
        returnValueToCaller1?("Driving")
        
        navigationController!.popViewController(animated: true)
        
        
    }
    
    
    var list = ["Highest Rating", "Lowest Rating", "Longest Time", "Shortest Time"]

    var imageArray = [UIImage(named:"1"),UIImage(named:"2"),UIImage(named:"3"),UIImage(named:"4"),UIImage(named:"5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("ttttttttttttttttffff\( self.tourCategory!)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath)
        as! ImageCollectionViewCell
        cell.imimage.image = imageArray[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ues")
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        cell.imimage.image = imageArray[1]

    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.textbox.text = self.list[row]
        self.dropdown.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textbox {
            self.dropdown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
    }
}

