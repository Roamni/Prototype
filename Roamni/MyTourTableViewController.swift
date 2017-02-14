//
//  MyTourTableViewController.swift
//  Roamni
//
//  Created by Hyman Li on 3/2/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import AVFoundation
import MediaPlayer
class MyTourTableViewController: UITableViewController,CLLocationManagerDelegate, AVAudioPlayerDelegate {
    static let sharedInstance = MyTourTableViewController()
    var tourCategory : String?
    var detailViewController: DetailViewController? = nil
    //var tours = [Tour]()
    //var filteredTours = [Tour]()
    var counter = 0
    var song = ["1","2","3"]
    var player = AVAudioPlayer()
    fileprivate var modalVC : ModalViewController!
    //let searchController = UISearchController(searchResultsController: nil)
    
    var urlString:String?
    var downloadTours = [DownloadTour]()
    var downloadTour:DownloadTour?
    var myGroup = DispatchGroup()
    var fileName:String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
         fetchTours()

//        tours = [
//            Tour(songid: 1,category:"walking", name:"Melbourne Central",locations:CLLocationCoordinate2D(latitude: -37.8426083, longitude: 144.9685646), desc: "This is the largest shopping centre, office and public transport hub in the city of Melbourne.", address:"211 La Trobe St, Melbourne", star:"1",length:"1",difficulty:"Pleasant"),
//            Tour(songid: 2,category:"walking", name:"Victoria Gallery",locations:CLLocationCoordinate2D(latitude: -35.8426083, longitude: 142.9685646), desc: "The public national gallery, popularly known as NGV, is an art museum in Melbourne.", address:"180 St Kilda Rd, Melbourne",star:"1",length:"1",difficulty:"Pleasant"),
//            Tour(songid: 3,category:"driving", name:"The Great Ocean Road",locations:CLLocationCoordinate2D(latitude: -38.6805638, longitude: 143.3894295), desc: "The Great Ocean Road is an Austrilian national heritage, a road along with the south-eastern coast of Austrilian.", address:"Great Ocean Rd, Victoria",star:"1",length:"1",difficulty:"Brisk")]
//        
        //        // Setup the Search Controller
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("the table category is \(self.tourCategory!)")
        super.viewWillAppear(animated)
        tableView.reloadData()

        //tableView
        //fetchTours()
        tableView.tableFooterView = UIView()
        super.viewDidLoad()
        //musicSlider.value = 0.0
        // Do any additional setup after loading the view, typically from a nib.
        if NSClassFromString("MPNowPlayingInfoCenter") != nil {
            let image:UIImage = UIImage(named: "logo_player_background")!
            let albumArt = MPMediaItemArtwork(image: image)
            let songInfo = [
                MPMediaItemPropertyTitle: "Radio Brasov",
                MPMediaItemPropertyArtist: "87,8fm",
                MPMediaItemPropertyArtwork: albumArt
                ] as [String : Any]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
            print("nonono")
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            print("Receiving remote control events\n")
        } catch {
            print("Audio Session error.\n")
        }


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
            
            
            let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: dictionary["star"] as! Int, length: "2", difficulty: "walking", uploadUser: dictionary["uploadUser"] as! String,tourId:snapshot.key)
            
            //            tour.Price = dictionary["Price"] as! String?
            //            tour.Star = dictionary["Star"] as! String?
            //            tour.StartPoint = dictionary["StartPoint"] as! String?
            //            tour.Time = dictionary["Time"] as! String?
            //            tour.TourType = dictionary["TourType"] as! String?
            //            tour.WholeTour = dictionary["WholeTour"] as! String?
            
            //self.artworks.removeAll()
            if let user = FIRAuth.auth()?.currentUser{
                let uid = user.uid
                
                if snapshot.childSnapshot(forPath: "user").hasChild(uid) || downloadTour.uploadUser == uid
                {
                    self.downloadTours.append(downloadTour)
                    print(self.downloadTours)
                    DispatchQueue.main.async(execute: {self.tableView.reloadData() } )

                }
                
            }
            else{
                print("no permission")
            }
            
        })
        
        
    }

    
    
    // MARK: - Segues
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let tour: DownloadTour
//
//                    tour = downloadTours[indexPath.row]
//                let controller = segue.destination as! DetailViewController
//                controller.detailTour = tour
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return downloadTours.count
        
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("????")
        counter = indexPath.row
        music()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.modalVC = storyboard.instantiateViewController(withIdentifier: "ModalViewController") as? ModalViewController
        self.modalVC.modalPresentationStyle = .overFullScreen

        self.present(self.modalVC, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniDownloadCell", for: indexPath) as! MyRoamniDownloadCell
        let tour: DownloadTour

            tour = downloadTours[indexPath.row]

        cell.textlabel!.text = tour.name
        cell.detailTextlabel!.text = tour.tourType
        cell.StarLabel.text = tour.length + " hr"//tour.star
//        cell.diffTextlabel.text = tour.difficulty
       // cell.counter = tour.songid - 1
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        let currentlocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let initialLocation = CLLocation(latitude: tour.startLocation.latitude, longitude: tour.startLocation.longitude)
        let distance = currentlocation.distance(from: initialLocation)
        let doubleDis : Double = distance
        let intDis : Int = Int(doubleDis)
        cell.distanceLabel.text = "\(intDis/1000) km"
//        cell.starrating = CGFloat((tour.star as NSString).floatValue)
        let starView = StarViewController()
        cell.delegate = starView
        cell.Pass()
        cell.isSelected = false
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "\(documentsDirectory)/voices/\(tour.name).m4a"
//        let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let filemanager = FileManager.default
        print(filemanager.fileExists(atPath: filePath))
        if(!filemanager.fileExists(atPath: filePath)){
            cell.downloadButton.setTitle("Download", for: .normal)
            cell.downloadButton.isEnabled = true
            cell.downProgress.isHidden = true

        }
        else
        {
            cell.downloadButton.setTitle("Downloaded", for: .normal)
            cell.downloadButton.isEnabled = false
            cell.downProgress.isHidden = true

        }
        cell.onButtonTapped={
            cell.downProgress.isHidden = false
            cell.downloadButton.setTitle("Downloading", for: .normal)
            let httpsReference = FIRStorage.storage().reference(forURL: tour.downloadUrl)
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            let filePath = "file:\(documentsDirectory)/voices/\(tour.name).m4a"
            let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            let downloadTask = httpsReference.write(toFile:fileURL!, completion: { (URL, error) -> Void in
                if (error != nil) {
                    print("error:"+(error?.localizedDescription)!)
                }
                else{
                    print("file path:"+filePath)
                }
            })
            downloadTask.observe(.progress) { (snapshot) in
                guard let progress = snapshot.progress else {return}
                cell.downProgress.progress  = Float(progress.fractionCompleted)
                if Int(cell.downProgress.progress) == 1{
                    cell.downloadButton.setTitle("Downloaded", for:.normal)
                    cell.downloadButton.isEnabled = false
                    cell.downProgress.isHidden = true
                }
            }

        }
        
        
        return cell
    }

    
    func music(){
        // isPlaying = true
       // print("counter is \(counter)")
        //let audioPath = Bundle.main.path(forResource: "\(counter)", ofType: "m4a")!
        let error : NSError? = nil
        //player = AVAudioPlayer(contentsOfURL: URL(string: audioPath), error: error)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let filePath = "file:\(documentsDirectory)/voices/\(self.downloadTours[self.counter].name).m4a"
         let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        do {
            print(fileURL)
            player = try AVAudioPlayer(contentsOf: fileURL!)
           print("hello")
        } catch {
            print("couldn't load file :(")
            
        }
        
//        musicSlider.maximumValue = Float(player.duration)
//        var timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.updateMusicSlider), userInfo: nil, repeats: true)
        player.delegate = self
        if error == nil {
     //       print("is playing!!!")
            player.delegate = self
            player.prepareToPlay()
            player.play()
        }
        
        
    }
    
    
    
    func counterMusic(counter: Int){
        // isPlaying = true
        print("counter is \(counter)")
        let audioPath = Bundle.main.path(forResource: "\(counter)", ofType: "m4a")!
        let error : NSError? = nil
        //player = AVAudioPlayer(contentsOfURL: URL(string: audioPath), error: error)
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(string: audioPath)!)
            print("hello")
        } catch {
            // couldn't load file :(
        }
        
        //        musicSlider.maximumValue = Float(player.duration)
        //        var timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.updateMusicSlider), userInfo: nil, repeats: true)
        player.delegate = self
        if error == nil {
            print("is playing!!!")
            player.delegate = self
            player.prepareToPlay()
            player.play()
        }
        
        
    }
    
    
    //配置NowPlayingCenter
    func configNowPlayingCenter(_ currentItem: AVURLAsset) {
        if (NSClassFromString("MPNowPlayingInfoCenter") != nil) {
            
            var songInfo = Dictionary<String, AnyObject>()
            
            let songTitle = currentItem.url.lastPathComponent.replacingOccurrences(of: ".m4a", with: "")
            
            let albumArt = MPMediaItemArtwork(image: UIImage(named: songTitle)!)
            songInfo[MPMediaItemPropertyTitle] = songTitle as AnyObject?
            songInfo[MPMediaItemPropertyArtist] = "Singer" as AnyObject?
            songInfo[MPMediaItemPropertyAlbumTitle] = "Album" as AnyObject?
            songInfo[MPMediaItemPropertyArtwork] = albumArt
            songInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1 as AnyObject?
            songInfo[MPMediaItemPropertyPlaybackDuration] = 238.837551020408 as AnyObject?//CMTimeGetSeconds(CMTimeMake(Int64(player.duration), 44100)) as AnyObject?
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        }
    }
    
    //
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    //Remote Control
    override func remoteControlReceived(with event: UIEvent?) {
        switch event?.subtype {
        case UIEventSubtype.remoteControlPlay?: // Music play
            player.play()
            break
        case UIEventSubtype.remoteControlPause?: // Music Pause
            player.pause()
            break
        case UIEventSubtype.remoteControlPreviousTrack?: //Last Song
            counter -= 1
            
            if ((counter) < 0) {
                counter = song.count - 1
            }
            print(counter)
            music()
            
            
            break;
        case UIEventSubtype.remoteControlNextTrack?: //Next Song
            counter += 1
            
            if ((counter ) == song.count) {
                counter = 0
            }
            
            music()
            
            break;
        case UIEventSubtype.remoteControlTogglePlayPause?: //Headphone Pause
            break
        default:
            break
        }
    }
    


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
