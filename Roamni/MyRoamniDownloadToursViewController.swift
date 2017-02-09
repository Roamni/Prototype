//
//  MyRoamniDownloadToursViewController.swift
//  Roamni
//
//  Created by zihaowang on 10/01/2017.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
class MyRoamniDownloadToursViewController: UIViewController {
    var urlString:String?
    var downloadTours = [DownloadTour]()
    var downloadTour:DownloadTour?
    var myGroup = DispatchGroup()
    var fileName:String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("here")
        fetchTours()
    
        

      //   let downloadTask =  httpsReference.data(withMaxSize: 10*1024*1024, completion: {(data, error) -> Void in
//            if (error != nil) {
//                // Uh-oh, an error occurred!
//                print(error?.localizedDescription)
//            } else {
//                print("finish")
//            }
//        })
//        myGroup.enter()
//        httpsReference.metadata(completion: {(metadata,error) in
//            if error != nil{
//                print(error?.localizedDescription)
//            }
//            else{
//                let name = metadata?.name
//                self.fileName = name
//                print(self.fileName)
//                self.myGroup.leave()
//                               }
//                    // Errors only occur in the "Failure" case
//        } )
//        myGroup.notify(queue: DispatchQueue.main, execute: {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        let filePath = "file:\(documentsDirectory)/voices/\(self.fileName!)"
//        let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//            
//        httpsReference.write(toFile:fileURL!, completion: { (URL, error) -> Void in
//            if (error != nil) {
//                print("error:"+(error?.localizedDescription)!)
//            }
//            else{
//                print("file path:"+filePath)
//                
//            }
//            })
//        })
//
    }
        func fetchTours(){
        var i = 1
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
            
        ref?.child("tours").observe(.childAdded, with:{ (snapshot) in
            
            let dictionary = snapshot.value as!  [String : Any]
            // tour.setValuesForKeys(dictionary)
            let startLocation = dictionary["startPoint"] as!  [String : Any]
            
            let endLocation = dictionary["endPoint"] as!  [String : Any]
            
            let latitude1 = String(describing: startLocation["lat"]!)
            
            let latitude = Double(latitude1)
            
            let longitude1 = String(describing: startLocation["lon"]!)
            
            let longitude = Double(longitude1)
            let latitude2 = String(describing: endLocation["lat"]!)
            
            let latitude22 = Double(latitude2)
            
            let longitude2 = String(describing: endLocation["lon"]!)
            
            let longitude22 = Double(longitude2)
            
            //let longitude = (location["lon"] as! NSString).doubleValue
            let startCoordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            let endCoordinate = CLLocationCoordinate2D(latitude: latitude22!, longitude: longitude22!)

            
            let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: dictionary["star"] as! Int, length: "2", difficulty: "walking", uploadUser: dictionary["uploadUser"] as! String)
            
            //            tour.Price = dictionary["Price"] as! String?
            //            tour.Star = dictionary["Star"] as! String?
            //            tour.StartPoint = dictionary["StartPoint"] as! String?
            //            tour.Time = dictionary["Time"] as! String?
            //            tour.TourType = dictionary["TourType"] as! String?
            //            tour.WholeTour = dictionary["WholeTour"] as! String?
            
                        //self.artworks.removeAll()
            if let user = FIRAuth.auth()?.currentUser{
                let uid = user.uid
                if downloadTour.uploadUser == uid
                {
                    self.downloadTours.append(downloadTour)
                    print(self.downloadTours)
                    let httpsReference = FIRStorage.storage().reference(forURL: downloadTour.downloadUrl)
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let documentsDirectory = paths[0]
                    let filePath = "file:\(documentsDirectory)/voices/\(i).m4a"
                    i += 1
                    let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    httpsReference.write(toFile:fileURL!, completion: { (URL, error) -> Void in
                        if (error != nil) {
                            print("error:"+(error?.localizedDescription)!)
                        }
                        else{
                            print("file path:"+filePath)
                        }
                    })
                }

                }
                else{
                    print("no permission")
                }
            
            })
            
            
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
