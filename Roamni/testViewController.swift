//
//  testViewController.swift
//  Roamni
//
//  Created by Zihao Wang on 28/3/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//
protocol ValueReturner {
    var returnValueToCaller: ((Any) -> ())?  { get set }
}

import UIKit
import ARNTransitionAnimator
class testViewController: UIViewController {

 //   @IBOutlet weak var playView: UIView!
    
    @IBOutlet weak var songTitle: UILabel!
    //@IBOutlet weak var songTitle: UILabel!

    @IBOutlet  fileprivate(set) weak var miniPlayerView: LineView!
    
    
   // @IBOutlet fileprivate(set) weak var miniPlayerView: LineView!
    @IBOutlet fileprivate(set) weak var miniPlayerButton: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
//    @IBOutlet fileprivate(set) weak var miniPlayerButton: UIButton!
    fileprivate var modalVC : ModalViewController!
    var tourCategory : String?
    var detailViewController: DetailViewController? = nil
    var getTableVCObject : ContainerTableViewController?
    var getMapVCObject : ContainerMapViewController?
    var tours = [DownloadTour]()
    var allTours = [DownloadTour]()
    var filteredTours = [DownloadTour]()
    var finalTours = [DownloadTour]()
    let searchController = UISearchController(searchResultsController: nil)
    private var animator : ARNTransitionAnimator?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.modalVC = storyboard.instantiateViewController(withIdentifier: "ModalViewController") as? ModalViewController
        self.modalVC.modalPresentationStyle = .overFullScreen
        let tabcontroller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        self.addChildViewController(tabcontroller)
        self.view.addSubview(tabcontroller.view)
        self.view.addSubview(self.miniPlayerView)
        tabcontroller.didMove(toParentViewController: self)
        
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        print("vvvvvvvv")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if (delegate.songTitle != nil){
            songTitle.text =  delegate.songTitle
            if delegate.player.isPlaying{
                playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
                songTitle.textColor = UIColor.white
            }
            else{
                playBtn.setImage(UIImage(named: "songplay"), for: UIControlState.normal)

            }
        }else{
            songTitle.text =  "Roamni"
            songTitle.textColor = UIColor.gray
        }

        
        //tours.removeAll()
        //print(self.tourCategory)
        //getTableVCObject?.tourCategory = self.tourCategory
        
        //filterContentForSearchText("more", scope: "Default")
        
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapMiniPlayerButton(_ sender: Any) {
        if songTitle.text ==  "Roamni"{
        }else{
            self.present(self.modalVC, animated: true, completion: nil)
        }
        
    }

    
    @IBAction func play(_ sender: Any) {
        if songTitle.text ==  "Roamni"{
        }else{

            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.player.isPlaying{
                delegate.player.pause()
                playBtn.setImage(UIImage(named: "songplay"), for: UIControlState.normal)
            }else{
                delegate.player.play()
                playBtn.setImage(UIImage(named: "songpause"), for: UIControlState.normal)
            }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

