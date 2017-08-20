/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import MapKit
import Firebase
import AVFoundation
import ReadMoreTextView
import Foundation
import StoreKit
class DetailViewController: UIViewController, MKMapViewDelegate, FloatRatingViewDelegate,UIScrollViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    /**
     Returns the rating value when touch events end
     */
    public func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
    }

    var ref:FIRDatabaseReference?
    var detailTour: DownloadTour?
    var allDetailTour = [DownloadTour]()
    var users:[String]?
    var currentIndex:Int?
    var aPlayer:AVPlayer!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var detailMap: MKMapView!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var circleProgressView: CircleProgressView!
    
    @IBOutlet weak var nextBn: UIBarButtonItem!
    @IBOutlet weak var preBn: UIBarButtonItem!
    @IBOutlet weak var seemoreBtn: UIButton!
    @IBOutlet weak var seelessBtn: UIButton!
    @IBOutlet weak var downloadprogress: UIProgressView!
    
    @IBOutlet weak var readMoreTextView: ReadMoreTextView!
    //var scrollView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    var downloadTours = [DownloadTour]()
    var list = [SKProduct]()
    var p = SKProduct()
    var hasUserbought = false
    fileprivate var modalVC : ModalViewController!
    var counter = 0
    
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
        
    }
    
    func removeAds() {
       // lblAd.removeFromSuperview()
    }
    
    func updatePriceButton() {
        priceBtn.backgroundColor = .clear
        priceBtn.layer.cornerRadius = 5
        priceBtn.layer.borderWidth = 1
        priceBtn.setTitle("Download", for: .normal)
        priceBtn.layer.borderColor = UIColor.green.cgColor
        priceBtn.setTitleColor(UIColor.green, for: UIControlState.normal)
        self.ref = FIRDatabase.database().reference()
        let detaiTourId = self.detailTour?.tourId
        let user = FIRAuth.auth()?.currentUser
        ref?.child("tours").child("\(detaiTourId!)").child("user").observe(.value, with:{ (snapshot) in
            if !snapshot.hasChild(user!.uid){
                self.ref?.child("tours").child("\(detaiTourId!)").child("user").child(user!.uid).setValue("buy")
            }
        })
        //SKPaymentQueue.defaultQueue().finishTransaction(transaction)

    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        print(response.products.count)
        
        if !response.invalidProductIdentifiers.isEmpty {
            print(response.invalidProductIdentifiers)
            //print()
        }
        //productsRequestCompletionHandler?(true, products)
        //clearRequestAndHandler()

        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            list.append(product)
            
        }
        
        //outRemoveAds.isEnabled = true
        //outAddCoins.isEnabled = true
        //outRestorePurchases.isEnabled = true
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "Roamni.Prototype.One.tourone":
                print("Roamni.Prototype.One.tourone")
          //      removeAds()
            case "Roamni.Prototype.One.tourtwo":
                print("Roamni.Prototype.One.tourtwo")
          //      addCoins()
            case "Roamni.Prototype.One.tourthreee":
                print("Roamni.Prototype.One.tourthreee")
                //      addCoins()
            case "Roamni.Prototype.One.tourfoure":
                print("Roamni.Prototype.One.tourfoure")
                //      addCoins()
            case "Roamni.Prototype.One.tourfivee":
                print("Roamni.Prototype.One.tourfivee")
                //      addCoins()
            case "Roamni.Prototype.One.toursixe":
                print("Roamni.Prototype.One.toursixe")
                //      addCoins()
            case "Roamni.Prototype.One.toursevene":
                print("Roamni.Prototype.One.toursevene")
                //      addCoins()
            case "Roamni.Prototype.One.toureighte":
                print("Roamni.Prototype.One.toureighte")
            //      addCoins()
            case "Roamni.Prototype.One.tourninee":
                print("Roamni.Prototype.One.tourninee")
            //      addCoins()
            case "Roamni.Prototype.One.tourtene":
                print("Roamni.Prototype.One.tourtene")
            //      addCoins()
            default:
                print("IAP not found")
            }
            queue.finishTransaction(transaction)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            if trans.error != nil{
                SKPaymentQueue.default().remove(self)
            }
            print("trans\(trans.error)")
            
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock IAP HERE")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier
                switch prodID {
                case "Roamni.Prototype.One.tourone":
                    print("tourone")
                    updatePriceButton()
                case "Roamni.Prototype.One.tourtwo":
                    print("tourtwo")
                    updatePriceButton()
                case "Roamni.Prototype.One.tourthreee":
                    print("tourthreee")
                   updatePriceButton()
                case "Roamni.Prototype.One.tourfoure":
                    print("tourfoure")
                    updatePriceButton()
                case "Roamni.Prototype.One.tourfivee":
                    print("tourfivee")
                    updatePriceButton()
                case "Roamni.Prototype.One.toursixe":
                    print("toursixe")
                    updatePriceButton()
                case "Roamni.Prototype.One.toursevene":
                    print("toursevene")
                    updatePriceButton()
                case "Roamni.Prototype.One.toureighte":
                    print("toureighte")
                    updatePriceButton()
                case "Roamni.Prototype.One.tourninee":
                    print("tourninee")
                    updatePriceButton()
                case "Roamni.Prototype.One.tourtene":
                    print("tourtene")
                    updatePriceButton()
                default:
                    print("IAP not found")
                }
                queue.finishTransaction(trans)
                SKPaymentQueue.default().finishTransaction(trans)
            case .failed:
                print("buy error")
                //SKPaymentQueue.default().add(self)
                //SKPaymentQueue.default().restoreCompletedTransactions()
                queue.finishTransaction(trans)
                SKPaymentQueue.default().finishTransaction(trans)
                break
            default:
                print("Default")
                break
            }
        
        }
        
    }

    
    @IBAction func nextAc(_ sender: Any) {
        self.detailTour = self.allDetailTour[currentIndex!+1]
        self.currentIndex! += 1
        self.viewDidLoad()

    }
    @IBAction func preAc(_ sender: Any) {
        if currentIndex != 0{
        self.detailTour = self.allDetailTour[currentIndex!-1]
        self.currentIndex! -= 1
        }
        self.viewDidLoad()

    }
    
    @IBAction func pressPriceBtn(_ sender: Any) {
        if self.priceBtn.titleLabel?.text != "Buy Tour" && self.priceBtn.titleLabel?.text != "Download" && self.priceBtn.titleLabel?.text != "Play"{
            priceBtn.backgroundColor = .clear
            priceBtn.layer.cornerRadius = 5
            priceBtn.layer.borderWidth = 1
            priceBtn.setTitle("Buy Tour", for: .normal)
            priceBtn.layer.borderColor = UIColor.green.cgColor
            priceBtn.setTitleColor(UIColor.green, for: UIControlState.normal)
            //titleLabel?.tintColor = UIColor.green
        }else if self.priceBtn.titleLabel?.text == "Download"{
            self.downloadprogress.isHidden = false
            //self.downloadAction.setTitle("Downloading", for: .normal)
            let httpsReference = FIRStorage.storage().reference(forURL: (detailTour?.downloadUrl)!)
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            let filePath = "file:\(documentsDirectory)/voices/\(detailTour!.name).m4a"
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
                self.downloadprogress.progress  = Float(progress.fractionCompleted)
                if Int(self.downloadprogress.progress) == 1{
                    //cell.downloadButton.setTitle("Downloaded", for:.normal)
                    self.priceBtn.backgroundColor = .clear
                    self.priceBtn.layer.cornerRadius = 5
                    self.priceBtn.layer.borderWidth = 1
                    self.priceBtn.setTitle("Play", for: .normal)
                    self.priceBtn.layer.borderColor = UIColor.green.cgColor
                    self.priceBtn.setTitleColor(UIColor.green, for: UIControlState.normal)
                    self.downloadprogress.isHidden = true
                }
            }

        }else if self.priceBtn.titleLabel?.text == "Play"{
            modalVC.counter = 1//self.counter
            print("countercounter\(self.counter)")
            modalVC.downloadTours = self.downloadTours
            print("calling!!")
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            let filePath = "\(documentsDirectory)/voices/\(self.detailTour!.name).m4a"
            //        let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            let filemanager = FileManager.default
            print(filemanager.fileExists(atPath: filePath))
            if(filemanager.fileExists(atPath: filePath)){
                print("playing!!")
                modalVC.music()
                modalVC.setLockView()
            }
            self.present(self.modalVC, animated: true, completion: nil)
        
        }else if self.priceBtn.titleLabel?.text == "Buy Tour"{
            if let user = FIRAuth.auth()?.currentUser{
                //self.userID? = user.uid
                print("in app purchase")
                if self.detailTour!.price == 9.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.tourtene") {
                            p = product
                            buyProduct()
                        }
                    }
                }else if self.detailTour!.price == 8.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.tourninee") {
                            p = product
                            buyProduct()
                        }
                    }
                
                }else if self.detailTour!.price == 7.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.toureighte") {
                            p = product
                            buyProduct()
                        }
                    }
                }else if self.detailTour!.price == 6.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.toursevene") {
                            p = product
                            buyProduct()
                        }
                    }
                }else if self.detailTour!.price == 5.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.toursixe") {
                            p = product
                            buyProduct()
                        }
                    }
                }else if self.detailTour!.price == 4.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.tourfivee") {
                            p = product
                            buyProduct()
                        }
                    }
                }else if self.detailTour!.price == 3.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.tourfoure") {
                            p = product
                            buyProduct()
                        }
                    }
                }else if self.detailTour!.price == 2.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.tourthreee") {
                            p = product
                            buyProduct()
                        }
                    }
                }else if self.detailTour!.price == 1.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.tourtwo") {
                            p = product
                            buyProduct()
                        }
                    }
                }else if self.detailTour!.price == 0.99{
                    for product in list {
                        let prodID = product.productIdentifier
                        if(prodID == "Roamni.Prototype.One.tourone") {
                            p = product
                            buyProduct()
                        }
                    }
                }
            }else {
                self.alertBn(title: "Error", message: "Please Log in")
            }
        }

    }

    
    @IBAction func preViewBn(_ sender: Any) {
        var timeObserver: AnyObject!
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        aPlayer = AVPlayer(url: NSURL(string: (self.detailTour?.downloadUrl)!)! as URL)
        let timeInterval: TimeInterval = 30.0
        let cmtime:CMTime = CMTimeMake(Int64(timeInterval), 1)
        let timeArray = NSValue(time: cmtime)
        
        timeObserver = aPlayer.addBoundaryTimeObserver(forTimes: [timeArray], queue:nil) { () -> Void in
            
            self.alertBn(title: "complete", message: "30 seconds reached")
//            self.aPlayer.removeTimeObserver(timeObserver)
               self.aPlayer.pause()
            
            //self.aPlayer = nil
        } as AnyObject!
        aPlayer.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        //aPlayer.
        let secondsDuration = self.aPlayer.currentItem?.currentTime().seconds
        self.circleProgressView.progress = Double(secondsDuration!/30)
        
        var player : AVAudioPlayer! = nil
        let delegate = UIApplication.shared.delegate as! AppDelegate
        player = delegate.player
        if player != nil{
        player.pause()
        }
        aPlayer.play()
        //let interval: TimeInterval = 0.05
        let interval = CMTime(seconds: 0.5,preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        aPlayer?.addPeriodicTimeObserver(forInterval:interval, queue: nil, using: { (time) in
            let currentTime = floor(CMTimeGetSeconds(time))
            print("30s reached\(self.aPlayer.currentTime().seconds)")
            self.circleProgressView.progress = Double(Float(self.aPlayer.currentTime().seconds)/30.0)
            // update UI should be in main thread
            DispatchQueue.main.async {
                //videoTimeRemainingLabel.text = String(currentTime)
            }
        })
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if aPlayer.currentItem?.status == AVPlayerItemStatus.readyToPlay{
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            aPlayer.currentItem?.removeObserver(self, forKeyPath: "status")
        }
        
    }
  
    @IBAction func downloadAction(_ sender: Any) {
        if let user = FIRAuth.auth()?.currentUser{
            let uid = user.uid
            self.ref = FIRDatabase.database().reference()
            let detaiTourId = self.detailTour?.tourId
            ref?.child("tours").child("\(detaiTourId!)").child("user").observe(.value, with:{ (snapshot) in
                if !snapshot.hasChild(uid){
                 self.ref?.child("tours").child("\(detaiTourId!)").child("user").child(uid).setValue("buy")
                }
            })
        self.alertBn(title: "Successful", message: "You have added this tour to your Mytour list")
        }
        else {
            self.alertBn(title: "Error", message: "Please Log in")
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    //@IBOutlet weak var lbl: TTTAttributedLabel!
    
    
    var index = 31
    
    @IBAction func seeless(_ sender: Any) {
        self.seemoreBtn.isHidden = false
        self.seelessBtn.isHidden = true
        self.scrollView.scrollToTop(animated: true)
    }
    
    @IBAction func seemoreandless(_ sender: Any) {
        self.seemoreBtn.isHidden = true
        self.seelessBtn.isHidden = false
        //self.scrollVie
        let fulldesArr = detailTour?.desc.components(separatedBy: " ")
        //index = index + 31
        if seemoreBtn.titleLabel?.text == "see more"{
            //self.descLabel.numberOfLines = 20
            //self.descLabel.text = self.detailTour?.desc
        }
        
        
    }
    
    func checkLess() {
        //paste your code here
        if readMoreTextView.text.contains("Read less"){
            self.scrollView.scrollToBottom()
        }
    }
    

    func fetchTours(){
        var ref:FIRDatabaseReference?
        var number = 0
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
                
                
                let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["duration"] as! Int, difficulty: "walking", uploadUser: dictionary["uploadUser"] as! String,tourId:child.key, price: Float(dictionary["price"] as! Float))
                
                if let user = FIRAuth.auth()?.currentUser{
                    let uid = user.uid
                    
                    if child.childSnapshot(forPath: "user").hasChild(uid) && downloadTour.uploadUser != uid
                    {
                        number = number + 1
                        if downloadTour.name == self.detailTour?.name{
                            self.hasUserbought = true
                            self.counter = number
                        }
                        self.downloadTours.append(downloadTour)
                        print(self.downloadTours)
                        print("?????\(self.downloadTours.count)")
                        
                        DispatchQueue.main.async(execute: {} )
                        
                    }
                    
                }
                else{
                    print("no permission")
                }
            }
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("count\(list.count)")
        //SKPaymentQueue.default().remove(self)
        //SKPaymentQueue.default().add(self)
        list.removeAll()
        self.counter = 0
        //self.downloadTours.removeAll()
        fetchTours()
        if self.hasUserbought == true{
            priceBtn.backgroundColor = .clear
            priceBtn.layer.cornerRadius = 5
            priceBtn.layer.borderWidth = 1
            priceBtn.setTitle("Download", for: .normal)
            priceBtn.layer.borderColor = UIColor.green.cgColor
            priceBtn.setTitleColor(UIColor.green, for: UIControlState.normal)
        }
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "\(documentsDirectory)/voices/\(self.detailTour?.name).m4a"
        //        let fileURL = URL(string: filePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let filemanager = FileManager.default
        print(filemanager.fileExists(atPath: filePath))
        if(filemanager.fileExists(atPath: filePath)){
            priceBtn.backgroundColor = .clear
            priceBtn.layer.cornerRadius = 5
            priceBtn.layer.borderWidth = 1
            priceBtn.setTitle("Play", for: .normal)
            priceBtn.layer.borderColor = UIColor.green.cgColor
            priceBtn.setTitleColor(UIColor.green, for: UIControlState.normal)
        }
        self.modalVC = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as? ModalViewController
        self.modalVC.modalPresentationStyle = .overFullScreen
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects: "Roamni.Prototype.One.tourone","Roamni.Prototype.One.tourtwo","Roamni.Prototype.One.tourthreee","Roamni.Prototype.One.tourfoure","Roamni.Prototype.One.tourfivee","Roamni.Prototype.One.toursixe","Roamni.Prototype.One.toursevene","Roamni.Prototype.One.toureighte","Roamni.Prototype.One.tourninee","Roamni.Prototype.One.tourtene")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SKPaymentQueue.default().add(self)
        fetchTours()
        self.downloadprogress.isHidden = true
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        if detailTour?.uploadUser == uid || self.hasUserbought == true{
            priceBtn.backgroundColor = .clear
            priceBtn.layer.cornerRadius = 5
            priceBtn.layer.borderWidth = 1
            priceBtn.setTitle("Download", for: .normal)
            priceBtn.layer.borderColor = UIColor.green.cgColor
            priceBtn.setTitleColor(UIColor.green, for: UIControlState.normal)
        }else{
            priceBtn.backgroundColor = .clear
            priceBtn.layer.cornerRadius = 5
            priceBtn.layer.borderWidth = 1
            priceBtn.layer.borderColor = UIColor.blue.cgColor
            priceBtn.setTitle("$ \(self.detailTour!.price)", for: .normal)
            print("jjjjjjj\(self.detailTour!.price)")
        }

    readMoreTextView.text = self.detailTour?.desc
    let readMoreTextAttributes: [String: Any] = [
        NSForegroundColorAttributeName: UIColor.lightGray,//view.tintColor,
        NSFontAttributeName: UIFont.systemFont(ofSize: 14)
        //self.scrollView.scrollToBottom()
    ]
    let readLessTextAttributes = [
        NSForegroundColorAttributeName: UIColor.lightGray,
        NSFontAttributeName: UIFont.systemFont(ofSize: 14)
    ]
    readMoreTextView.attributedReadMoreText = NSAttributedString(string: "... Read more", attributes: readMoreTextAttributes)
    readMoreTextView.attributedReadLessText = NSAttributedString(string: " Read less", attributes: readLessTextAttributes)
    readMoreTextView.maximumNumberOfLines = 3
    readMoreTextView.shouldTrim = true
    self.scrollView.contentSize = CGSize(width: 375, height: 659)
   // self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)
    self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    self.scrollView.minimumZoomScale=1
    self.scrollView.maximumZoomScale=3
    self.scrollView.bounces=false
    self.scrollView.delegate=self
    self.view.addSubview(self.scrollView)
    if self.detailMap.annotations.count != 0
    {

        self.detailMap.removeAnnotations(self.detailMap.annotations)
    }
    navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
    
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    //configureView()
    self.titleLabel.text = detailTour?.name
    self.titleLabel.adjustsFontSizeToFitWidth = true
    //
    if currentIndex == self.allDetailTour.count-1{
        self.nextBn.isEnabled = false
    }
    else{
        self.nextBn.isEnabled = true
    }
    if currentIndex == 0{
        self.preBn.isEnabled = false
    }
    else
    {
        self.preBn.isEnabled = true
    }

    //self.title = detailTour?.name
    self.lengthLabel.text = String(detailTour?.length ?? 0) + " min"
    self.ratingLabel.text = String(describing: detailTour?.star)
    let fulldesArr = detailTour?.desc.components(separatedBy: " ")
    if (fulldesArr?.count)! >= 31{
        let halfdesArr  = fulldesArr?[0 ..< 31]
        let descText = halfdesArr?.joined(separator: " ")
        //self.descLabel.text = descText
    }else{
        //self.descLabel.text = detailTour?.desc
        //self.seemoreBtn.isHidden = true
    }

    detailMap.delegate = self
    let sourceLocation = detailTour?.startLocation
    self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
    self.floatRatingView.fullImage = UIImage(named: "StarFull")
    // Optional params
    self.floatRatingView.delegate = self
    self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
    self.floatRatingView.maxRating = 5
    self.floatRatingView.minRating = 1
    //Set star rating
    self.floatRatingView.rating = (detailTour?.star)!
    self.floatRatingView.editable = false
    
    let destinationLocation = CLLocationCoordinate2D(latitude: (detailTour?.endLocation.latitude)!, longitude: (detailTour?.endLocation.longitude)!)
    let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
    let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
    let sourceMapItem =  MKMapItem(placemark: sourcePlacemark)
    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    let sourceAnnotation = MKPointAnnotation()
    sourceAnnotation.title = detailTour?.name
    if let location = sourcePlacemark.location{
        sourceAnnotation.coordinate = location.coordinate
    }
    let place = TourForMap(title: sourceAnnotation.title!, info: "Start Point", coordinate: sourceAnnotation.coordinate)
    detailMap.addAnnotation(place)

    
    //self.detailMap.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    //places.append(place)
    
    let destinationAnnotation = MKPointAnnotation()
    destinationAnnotation.title = "Destination"
    if let location = destinationPlacemark.location{
        destinationAnnotation.coordinate = location.coordinate
    }
    self.detailMap.showAnnotations([/*sourceAnnotation,*/destinationAnnotation], animated: true)
    let directionRequest = MKDirectionsRequest()
    directionRequest.source = sourceMapItem
    directionRequest.destination = destinationMapItem
    directionRequest.transportType = .any
    let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    self.detailMap.setRegion(region, animated: true)
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay:overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
        
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
    //Set pin`s look and pin event
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Let each annotation as CategoryForMap
        print("whatwhatwhat?")
        if let annotation = annotation as? TourForMap{
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            view.pinTintColor = UIColor.green
            return view
        }
        return nil
    }

    

}
extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y, width:1, height:self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}



