//
//  SearchContainerViewController.swift
//  Roamni
//
//  Created by Hyman Li on 18/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//
protocol ValueReturner {
    var returnValueToCaller: ((Any) -> ())?  { get set }
}
import UIKit
import CoreLocation
import ARNTransitionAnimator
class SearchContainerViewController: UIViewController {

    
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet fileprivate(set) weak var tabBar: UITabBar!
    @IBOutlet fileprivate(set) weak var miniPlayerView: LineView!
    
    @IBOutlet fileprivate(set) weak var miniPlayerButton: UIButton!
    fileprivate(set) weak var container: ContainerViewController!
    var tourCategory : String?
    @IBOutlet weak var swtichBtn: UIBarButtonItem!
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        //clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        if self.swtichBtn.image == UIImage(named: "list") && (getTableVCObject?.tableView((getTableVCObject?.tableView)!, numberOfRowsInSection: 1))! != tours.count{
            getMapVCObject = self.container.currentViewController as? ContainerMapViewController
            getMapVCObject?.places.removeAll()
            getMapVCObject?.tours = finalTours
        }
        var delegate = UIApplication.shared.delegate as! AppDelegate
        songTitle.text =  delegate.songTitle
        
        //tours.removeAll()
        //print(self.tourCategory)
        //getTableVCObject?.tourCategory = self.tourCategory
        
        //filterContentForSearchText("more", scope: "Default")
          


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.modalVC = storyboard.instantiateViewController(withIdentifier: "ModalViewController") as? ModalViewController
        self.modalVC.modalPresentationStyle = .overFullScreen
        
        let color = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.3)
        self.miniPlayerButton.setBackgroundImage(self.generateImageWithColor(color), for: .highlighted)
        
        self.setupAnimator()

        
        navigationController?.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 24.0/255.0, blue: 57.0/255.0, alpha: 1.0)
         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //self.tourCategory = "currentLocation"
        container!.segueIdentifierReceivedFromParent("first")
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Default", "Rating", "Length"]
        getTableVCObject = self.container.currentViewController as? ContainerTableViewController
        getTableVCObject?.tableView.tableHeaderView = searchController.searchBar
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers

            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
            finalTours = tours

           
        }
        
        getTableVCObject?.tours = self.tours
        getTableVCObject?.tableView.reloadData()
        
        if self.tourCategory != nil{
            
            filterContentForSearchText(self.tourCategory!, scope: "Default")
            searchController.isActive = true
        }
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func setupAnimator() {
        let animation = MusicPlayerTransitionAnimation(rootVC: self, modalVC: self.modalVC)
        animation.completion = { [weak self] isPresenting in
            if isPresenting {
                guard let _self = self else { return }
                let modalGestureHandler = TransitionGestureHandler(targetVC: _self, direction: .bottom)
                modalGestureHandler.registerGesture(_self.modalVC.view)
                modalGestureHandler.panCompletionThreshold = 15.0
                _self.animator?.registerInteractiveTransitioning(.dismiss, gestureHandler: modalGestureHandler)
            } else {
                self?.setupAnimator()
            }
        }
        
        let gestureHandler = TransitionGestureHandler(targetVC: self, direction: .top)
        gestureHandler.registerGesture(self.miniPlayerView)
        gestureHandler.panCompletionThreshold = 15.0
        
        self.animator = ARNTransitionAnimator(duration: 0.5, animation: animation)
        self.animator?.registerInteractiveTransitioning(.present, gestureHandler: gestureHandler)
        
        self.modalVC.transitioningDelegate = self.animator
    }

    
    @IBAction func tapMiniPlayerButton() {
      //  self.present(self.modalVC, animated: true, completion: nil)

    }
    
    
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
            let controller:FilterTableViewController = segue.destination as! FilterTableViewController
            
            controller.tours = self.tours
            controller.returnValueToCaller=handleFilter
        
        }
    }
    
    func handleFilter(returnedValue:Any)
    {
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
                case "Default" :
                    fieldToSearch = tour.name
                case "Rating":
                    fieldToSearch = String(tour.star)
                case "Length":
                    fieldToSearch = tour.length
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
        }
}

    extension SearchContainerViewController: UISearchResultsUpdating {
        // MARK: - UISearchResultsUpdating Delegate
        func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        }
    
}




