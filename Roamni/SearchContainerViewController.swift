//
//  SearchContainerViewController.swift
//  Roamni
//
//  Created by Hyman Li on 18/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//
//protocol ValueReturner {
//    var returnValueToCaller: ((Any) -> ())?  { get set }
//}
import UIKit
import CoreLocation
import ARNTransitionAnimator
import FirebaseDatabase
class SearchContainerViewController: UIViewController {

    
    
    fileprivate(set) weak var container: ContainerViewController!
    
    @IBOutlet weak var swtichBtn: UIBarButtonItem!
    
    var tourCategory : String?
    var isCurrentInstruction = false
    var detailViewController: DetailViewController? = nil
    var getTableVCObject : ContainerTableViewController?
    var getMapVCObject : ContainerMapViewController?
    var tours = [DownloadTour]()
    var allTours = [DownloadTour]()
    var filteredTours = [DownloadTour]()
    var finalTours = [DownloadTour]()
    let searchController = UISearchController(searchResultsController: nil)
    private var animator : ARNTransitionAnimator?
    fileprivate var modalVC : ModalViewController!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidAppear(_ animated: Bool) {
        //clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        if self.swtichBtn.image == UIImage(named: "list") && (getTableVCObject?.tableView((getTableVCObject?.tableView)!, numberOfRowsInSection: 1))! != tours.count{
            getMapVCObject = self.container.currentViewController as? ContainerMapViewController
            getMapVCObject?.places.removeAll()
            getMapVCObject?.tours = finalTours
        }
        print("aaaaaaa!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        container!.segueIdentifierReceivedFromParent("first")
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Tour Name", "Rating", "Length"]
        searchController.searchBar.showsScopeBar = false
        getTableVCObject = self.container.currentViewController as? ContainerTableViewController
        getTableVCObject?.tableView.tableHeaderView = searchController.searchBar
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers

            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
            finalTours = tours
        }
        if self.tourCategory != nil{
           fetchTours(flag: "type")
            searchController.isActive = true
        }else{
        fetchTours(flag: "flag")
       
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTours(flag:String){
        var ref:FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
        ref?.child("tours").observeSingleEvent(of:.value, with:{ (snapshot) in
            let result = snapshot.children.allObjects as? [FIRDataSnapshot]
            if result?.count == 0
            {
                self.activityIndicator.stopAnimating()

            }
            for child in result!{
                let dictionary = child.value as!  [String : Any]            // tour.setValuesForKeys(dictionary)
                print(dictionary)
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
                
                let downloadTour = DownloadTour(tourType: dictionary["TourType"] as! String, name: dictionary["name"] as! String, startLocation: startCoordinate, endLocation: endCoordinate, downloadUrl: dictionary["downloadURL"] as! String, desc: dictionary["desc"] as! String, star: Float(dictionary["star"] as! Float), length: dictionary["duration"] as! Int, difficulty: "Pleasant", uploadUser: dictionary["uploadUser"] as! String,tourId: child.key, price: Float(dictionary["price"] as! Float))
                //            tour.Price = dictionary["Price"] as! String?
                //            tour.Star = dictionary["Star"] as! String?
                //            tour.StartPoint = dictionary["StartPoint"] as! String?
                //            tour.Time = dictionary["Time"] as! String?
                //            tour.TourType = dictionary["TourType"] as! String?
                //            tour.WholeTour = dictionary["WholeTour"] as! String?
                
                //self.artworks.removeAll()
                print(startCoordinate)
                self.tours.append(downloadTour)
                if flag == "type"
                {
                    self.filterContentForSearchText(self.tourCategory!, scope: "Tour Name")
                    //print("typetype")
                }
                else{
                    self.getTableVCObject?.tours = self.tours
                    self.getTableVCObject?.tableView.reloadData()
                    //print("nonotype")
                }
                self.activityIndicator.stopAnimating()
    //            if self.filteredTours.count == 0 || self.tours.count == 0{
    //                self.getTableVCObject?.noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: (self.getTableVCObject?.tableView.bounds.size.width)!, height: (self.getTableVCObject?.tableView.bounds.size.height)!))
   //                 self.getTableVCObject?.noDataLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
   //                 self.getTableVCObject?.noDataLabel?.numberOfLines = 3
  //                  self.getTableVCObject?.noDataLabel?.text = "There are no \(self.tourCategory!) tours in your area. Be the first to create one! Open Voicememos, record and upload!"
  //                  self.getTableVCObject?.noDataLabel?.textColor = UIColor.black
 //                   self.getTableVCObject?.noDataLabel?.textAlignment = .center
 //                   self.getTableVCObject?.tableView.backgroundView = self.getTableVCObject?.noDataLabel
 //                   self.getTableVCObject?.tableView.separatorStyle = .none
 //               }else{
//                    self.getTableVCObject?.noDataLabel?.text = ""
//                }

            }
            
        })
        
    }

    
    
    @IBAction func test(_ sender: Any) {
        //container!.segueIdentifierReceivedFromParent("first")
        if self.swtichBtn.image == UIImage(named: "map"){
                self.swtichBtn.image = UIImage(named: "list")
                container!.segueIdentifierReceivedFromParent("second")
                getMapVCObject = self.container.currentViewController as? ContainerMapViewController
            if finalTours.count == 0 || (getTableVCObject?.tableView((getTableVCObject?.tableView)!, numberOfRowsInSection: 1))! == tours.count{
                getMapVCObject?.tours = self.tours
                getMapVCObject?.places.removeAll()
            }else{
                getMapVCObject?.tours = finalTours
                 getMapVCObject?.places.removeAll()
            }
        }else{
                self.swtichBtn.image = UIImage(named: "map")
                container!.segueIdentifierReceivedFromParent("first")
                searchController.isActive = false
        }
        
    }

//    func setupAnimator() {
//        let animation = MusicPlayerTransitionAnimation(rootVC: self, modalVC: self.modalVC)
//        animation.completion = { [weak self] isPresenting in
//            if isPresenting {
//                guard let _self = self else { return }
//                let modalGestureHandler = TransitionGestureHandler(targetVC: _self, direction: .bottom)
//                modalGestureHandler.registerGesture(_self.modalVC.view)
//                modalGestureHandler.panCompletionThreshold = 15.0
//                _self.animator?.registerInteractiveTransitioning(.dismiss, gestureHandler: modalGestureHandler)
//            } else {
//                self?.setupAnimator()
//            }
//        }
//        
//        let gestureHandler = TransitionGestureHandler(targetVC: self, direction: .top)
//        gestureHandler.registerGesture(self.miniPlayerView)
//        gestureHandler.panCompletionThreshold = 15.0
//        
//        self.animator = ARNTransitionAnimator(duration: 0.5, animation: animation)
//        self.animator?.registerInteractiveTransitioning(.present, gestureHandler: gestureHandler)
//        
//        self.modalVC.transitioningDelegate = self.animator
//    }

    
    
    
    fileprivate func generateImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            container = segue.destination as! ContainerViewController
        }
        if segue.identifier == "filter"
        {
            let controller:FilterViewController = segue.destination as! FilterViewController
            
            controller.tours = self.tours
            controller.returnValueToCaller=handleFilter
        
        }
    }
    
    func handleFilter(returnedValue:Any){
        self.getTableVCObject?.tours = returnedValue as! [DownloadTour]
        self.getTableVCObject?.tableView.reloadData()
    
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        //searchController.dismissViewControllerAnimated()
        getTableVCObject?.tours = finalTours
        getTableVCObject?.filteredTours = finalTours
        getTableVCObject?.tableView.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
               filteredTours = tours.filter({( tour : DownloadTour) -> Bool in
                var fieldToSearch:String?
                switch scope {
                case "Tour Name" :
                    fieldToSearch = tour.name
                case "Rating":
                    fieldToSearch = String(tour.star)
                case "Length":
                    fieldToSearch = String(tour.length)
                default:
                    fieldToSearch = nil
                }
                if fieldToSearch == nil{
                   self.filteredTours.removeAll()
                    return false
                }

          //  let categoryMatch = (scope == "Default") || (tour.category == scope)
            
            return fieldToSearch!.lowercased().contains(searchText.lowercased()) ||  tour.tourType.lowercased().contains(searchText.lowercased())

        })
        
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as! UITextField
        
        if filteredTours.count == 0 && textFieldInsideSearchBar.text == ""{
            getTableVCObject?.tours = tours
            getTableVCObject?.filteredTours = tours
            getTableVCObject?.tableView.reloadData()
            
        }else{
            getTableVCObject?.tours = filteredTours
            getTableVCObject?.filteredTours = filteredTours
            getTableVCObject?.tableView.reloadData()
            finalTours.removeAll()
            finalTours = filteredTours
            
        }
        
        if filteredTours.count == 0 || tours.count == 0 {
            if self.activityIndicator.isAnimating == false{
                getTableVCObject?.noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: (getTableVCObject?.tableView.bounds.size.width)!, height: (getTableVCObject?.tableView.bounds.size.height)!))
                getTableVCObject?.noDataLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                getTableVCObject?.noDataLabel?.numberOfLines = 3
                getTableVCObject?.noDataLabel?.text = "There are no \(searchText) tours in your area. Be the first to create one! Open Voicememos, record and upload!"
                getTableVCObject?.noDataLabel?.textColor = UIColor.black
                getTableVCObject?.noDataLabel?.textAlignment = .center
                getTableVCObject?.tableView.backgroundView = getTableVCObject?.noDataLabel
                getTableVCObject?.tableView.separatorStyle = .none
            }else{
                getTableVCObject?.noDataLabel?.text = ""
                }
        }else{
            getTableVCObject?.noDataLabel?.text = ""
        }
        //let getTableVCObject = self.container.currentViewController as? ContainerTableViewController
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

    extension SearchContainerViewController: UISearchBarDelegate {
        // MARK: - UISearchBar Delegate
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        
            
        
            }}

    extension SearchContainerViewController: UISearchResultsUpdating {
        // MARK: - UISearchResultsUpdating Delegate
        func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            filterContentForSearchText(searchController.searchBar.text!, scope: scope)
            
        }
        
      
}






