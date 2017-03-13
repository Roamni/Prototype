//
//  ViewController.swift
//  Collectionview Horizontal Image
//
//  Created by Hyman Li on 7/3/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

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
}

