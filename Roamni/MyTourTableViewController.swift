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
class MyTourTableViewController: UITableViewController,CLLocationManagerDelegate, AVAudioPlayerDelegate,  FloatRatingViewDelegate {
    
    @IBOutlet weak var segCon: UISegmentedControl!

    
    @IBAction func sgeChange(_ sender: UISegmentedControl) {
        switch self.segCon.selectedSegmentIndex{
        case 0 :
            self.downloadTours.removeAll()
            fetchTours()
            tableView.reloadData()
            break
            
        case 1 :
            self.downloadTours.removeAll()
            fetchTours1()
            tableView.reloadData()
            break
        default:
            break
        }
    
    }

    
    static let sharedInstance = MyTourTableViewController()
    var tourCategory : String?
    var detailViewController: DetailViewController? = nil
    //var tours = [Tour]()
    //var filteredTours = [Tour]()
    var counter = 0
    var song = ["1","2","3"]
    var player = AVAudioPlayer()
    fileprivate var modalVC : ModalViewController!
    fileprivate var testView : MyTourTableViewController!
    //fileprivate var my : ModalViewController!
    //let searchController = UISearchController(searchResultsController: nil)
    var musictitle = "Roamni"
    var musicartist = "Roamni"
    var urlString:String?
    var downloadTours = [DownloadTour]()
    var downloadTour:DownloadTour?
    var myGroup = DispatchGroup()
    var fileName:String? = nil
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating:Float) {
        // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
//    override func viewDidLoad() {
//        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        tabBarController?.tabBar.tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
//
//        super.viewDidLoad()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//         fetchTours()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        self.modalVC = storyboard.instantiateViewController(withIdentifier: "ModalViewController") as? ModalViewController
//        self.modalVC.modalPresentationStyle = .overFullScreen
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("the table category is \(self.tourCategory!)")
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tabBarController?.tabBar.tintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.modalVC = storyboard.instantiateViewController(withIdentifier: "ModalViewController") as? ModalViewController
        self.modalVC.modalPresentationStyle = .overFullScreen
        
        if let user = FIRAuth.auth()?.currentUser{
        
       
        self.downloadTours.removeAll()
        fetchTours()
        tableView.reloadData()

        //tableView
        
        }
        else{
            self.alertBn(title: "Error", message: "Please Log In")
        }
        super.viewDidLoad()
        //musicSlider.value = 0.0
        // Do any additional setup after loading the view, typically from a nib.
//        if NSClassFromString("MPNowPlayingInfoCenter") != nil {
//            let image:UIImage = UIImage(named: "logo_player_background")!
//            let albumArt = MPMediaItemArtwork(image: image)
//            let songInfo = [
//                MPMediaItemPropertyTitle: "\(self.musictitle)",
//                MPMediaItemPropertyArtist: "\(self.musicartist)",
//                MPMediaItemPropertyArtwork: albumArt
//                ] as [String : Any]
//            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
//            print("nonono")
//        }
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            UIApplication.shared.beginReceivingRemoteControlEvents()
//            print("Receiving remote control events\n")
//        } catch {
//            print("Audio Session error.\n")
//        }
       

    }
    
    func fetchTours(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("tours").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            for child in result!{
                let dictionary = child.value as!  [String : Any]
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
            
            
            let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["duration"] as! Int, difficulty: "walking", uploadUser: dictionary["uploadUser"] as! String,tourId:child.key)
            
            //            tour.Price = dictionary["Price"] as! String?
            //            tour.Star = dictionary["Star"] as! String?
            //            tour.StartPoint = dictionary["StartPoint"] as! String?
            //            tour.Time = dictionary["Time"] as! String?
            //            tour.TourType = dictionary["TourType"] as! String?
            //            tour.WholeTour = dictionary["WholeTour"] as! String?
            
            //self.artworks.removeAll()
            if let user = FIRAuth.auth()?.currentUser{
                let uid = user.uid
                
                if child.childSnapshot(forPath: "user").hasChild(uid)
                {
                    self.downloadTours.append(downloadTour)
                    print(self.downloadTours)
                    DispatchQueue.main.async(execute: {self.tableView.reloadData() } )

                }
                
            }
            else{
                print("no permission")
            }
            }
        })
        
        
    }

    func fetchTours1(){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("tours").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            for child in result!{
                let dictionary = child.value as!  [String : Any]
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
                
                
                let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["duration"] as! Int, difficulty: "walking", uploadUser: dictionary["uploadUser"] as! String,tourId:child.key)
                
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
                        DispatchQueue.main.async(execute: {self.tableView.reloadData() } )
                        
                    }
                    
                }
                else{
                    print("no permission")
                }
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

        //self.present(self.modalVC, animated: true, completion: nil)
        self.counter = indexPath.row
//        self.modalVC.downloadTours = self.downloadTours
//        if self.modalVC.player != nil {
//            if self.modalVC.player.isPlaying {
//                self.modalVC.player.stop()
//            }
//            else{
//                print("nothing is playing")
//            }
//        }
//        self.modalVC.music()
//        self.modalVC.setLockView()
//        self.musictitle = downloadTours[counter].name
//        self.musicartist = downloadTours[counter].difficulty
        //modalVC
        //let controller = segue.destination as! ModalViewController
        // let controller: NewCategoryViewController = navController.viewControllers[0] as! NewCategoryViewController
        // Get managedObjectContext and pass to controller
        //controller.managedObjectContext = self.managedObjectContext
        
        modalVC.counter = self.counter
        modalVC.downloadTours = self.downloadTours
        print("calling!!")
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "\(documentsDirectory)/voices/\(self.downloadTours[counter].name).m4a"
        //        let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let filemanager = FileManager.default
        print(filemanager.fileExists(atPath: filePath))
        if(filemanager.fileExists(atPath: filePath)){
            modalVC.music()
            modalVC.setLockView()
        }
            
        else{
            self.alertBn(title: "Reminder", message: "Please download this tour")
            
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.testView = storyboard.instantiateViewController(withIdentifier: "MyTourTableViewController") as? MyTourTableViewController
        //self.testView.modalPresentationStyle = .overFullScreen
        //self.present(self.testView, animated: true, completion: nil)
        self.present(self.modalVC, animated: true, completion: nil)

        //self.performSegue(withIdentifier: "goMusicDetail", sender: self)
        
        //self.performSegue(withIdentifier: "ShowDetailView", sender: itemString)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoamniDownloadCell", for: indexPath) as! MyRoamniDownloadCell
        let tour: DownloadTour

            tour = downloadTours[indexPath.row]

        cell.textlabel!.text = tour.name
        cell.detailTextlabel!.text = tour.tourType
        cell.StarLabel.text = String(tour.length) + " min"//tour.star
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
        cell.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        cell.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        cell.floatRatingView.delegate = self
        cell.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        cell.floatRatingView.maxRating = 5
        cell.floatRatingView.minRating = 1
        //Set star rating
        cell.floatRatingView.rating = tour.star
        cell.floatRatingView.editable = false
        
        
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
    
    func setLockView(){
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle:"第一夫人",
            MPMediaItemPropertyArtist:"张杰",
            MPMediaItemPropertyArtwork:MPMediaItemArtwork(image: UIImage(named: "img.jpeg")!),
            MPNowPlayingInfoPropertyPlaybackRate:1.0,
            MPMediaItemPropertyPlaybackDuration:player.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime:player.currentTime
        ]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goMusicDetail"
        {
            //Lead user from currnet controller to NewCategoryViewController
            let controller = segue.destination as! ModalViewController
           // let controller: NewCategoryViewController = navController.viewControllers[0] as! NewCategoryViewController
            // Get managedObjectContext and pass to controller
            //controller.managedObjectContext = self.managedObjectContext

            controller.counter = self.counter
            controller.downloadTours = self.downloadTours
            print("calling!!")
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            let filePath = "\(documentsDirectory)/voices/\(self.downloadTours[counter].name).m4a"
            //        let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            let filemanager = FileManager.default
            print(filemanager.fileExists(atPath: filePath))
            if(filemanager.fileExists(atPath: filePath)){
            controller.music()
            controller.setLockView()
            }

        else{
            self.alertBn(title: "Reminder", message: "Please download this tour")
            
            }

            
        }
        
    
    }
    
    func passPlayer(player: AVAudioPlayer)
    {
        
    }
//    //配置NowPlayingCenter
//    func configNowPlayingCenter(_ currentItem: AVURLAsset) {
//        if (NSClassFromString("MPNowPlayingInfoCenter") != nil) {
//            
//            var songInfo = Dictionary<String, AnyObject>()
//            
//            let songTitle = currentItem.url.lastPathComponent.replacingOccurrences(of: ".m4a", with: "")
//            
//            let albumArt = MPMediaItemArtwork(image: UIImage(named: songTitle)!)
//            songInfo[MPMediaItemPropertyTitle] = songTitle as AnyObject?
//            songInfo[MPMediaItemPropertyArtist] = "Singer" as AnyObject?
//            songInfo[MPMediaItemPropertyAlbumTitle] = "Album" as AnyObject?
//            songInfo[MPMediaItemPropertyArtwork] = albumArt
//            songInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1 as AnyObject?
//            songInfo[MPMediaItemPropertyPlaybackDuration] = player.duration as AnyObject?//CMTimeGetSeconds(CMTimeMake(Int64(player.duration), 44100)) as AnyObject?
//            
//            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
//        }
//    }
    
    //
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
//    override func remoteControlReceived(with event: UIEvent?) {
//        switch event!.subtype {
//        case .remoteControlPlay:  // play按钮
//            player.play()
//        case .remoteControlPause:  // pause按钮
//            player.pause()
//        case .remoteControlNextTrack:  // next
//            // ▶▶ 押下時の処理
//            break
//        case .remoteControlPreviousTrack:  // previous
//            // ◀◀ 押下時の処理
//            break
//        default:
//            break
//        }
//    }
    
//    //Remote Control
//    override func remoteControlReceived(with event: UIEvent?) {
//        switch event?.subtype {
//        case UIEventSubtype.remoteControlPlay?: // Music play
//            player.play()
//            break
//        case UIEventSubtype.remoteControlPause?: // Music Pause
//            player.pause()
//            break
//        case UIEventSubtype.remoteControlPreviousTrack?: //Last Song
//            counter -= 1
//            
//            if ((counter) < 0) {
//                counter = song.count - 1
//            }
//            print(counter)
//            music()
//            
//            
//            break;
//        case UIEventSubtype.remoteControlNextTrack?: //Next Song
//            counter += 1
//            
//            if ((counter ) == song.count) {
//                counter = 0
//            }
//            
//            music()
//            
//            break;
//        case UIEventSubtype.remoteControlTogglePlayPause?: //Headphone Pause
//            break
//        default:
//            break
//        }
//    }
    


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
