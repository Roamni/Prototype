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
    var Fcontroller:SearchContainerViewController?
    var tours = [DownloadTour]()

    
    @IBOutlet weak var textbox: UITextField!
    
    @IBOutlet weak var dropdown: UIPickerView!
    
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

        case "Longest duration":
            self.tours.sort(by: { (this:DownloadTour, that:DownloadTour) -> Bool in
                return this.length < that.length
            })
            break

        case "Shortest duration":
            self.tours.sort(by: { (this:DownloadTour, that:DownloadTour) -> Bool in
                return this.length > that.length
            })
            break

        default:
            self.tours.sort(by: sortForTours)
        }
        returnValueToCaller?(self.tours)
        navigationController!.popViewController(animated: true)

        
    }
    
    
    var list = ["Highest Rating", "Lowest Rating", "Longest duration", "Shortest duration"]

    var imageArray = [UIImage(named:"1"),UIImage(named:"2"),UIImage(named:"3"),UIImage(named:"4"),UIImage(named:"5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        var cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
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

