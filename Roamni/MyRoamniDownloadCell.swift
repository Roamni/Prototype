//
//  MyRoamniDownloadCell.swift
//  Roamni
//
//  Created by zihaowang on 10/01/2017.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MyRoamniDownloadCell: UITableViewCell, AVAudioPlayerDelegate {

 
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var detailTextlabel: UILabel!
    @IBOutlet weak var textlabel: UILabel!
    @IBOutlet weak var StarLabel: UILabel!

    var counter = 1
    
    var starrating:CGFloat = 1
    var delegate:RatingBarDelegate?
    var player = AVAudioPlayer()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func Pass()
    {
        delegate?.ratingDidChange(ratings: starrating)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        if selected == false{
        
       //MyTourTableViewController.sharedInstance.counterMusic(counter: counter)
        }
        

}
    
    
//    func music(){
//        // isPlaying = true
//        print("counter is \(songId)")
//        let audioPath = Bundle.main.path(forResource: "1", ofType: "m4a")!
//        let error : NSError? = nil
//        //player = AVAudioPlayer(contentsOfURL: URL(string: audioPath), error: error)
//        
//        do {
//            player = try AVAudioPlayer(contentsOf: URL(string: audioPath)!)
//            print("hello")
//        } catch {
//            // couldn't load file :(
//        }
//        
//        //        musicSlider.maximumValue = Float(player.duration)
//        //        var timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.updateMusicSlider), userInfo: nil, repeats: true)
//        player.delegate = self
//        if error == nil {
//            print("is playing!!!")
//            player.delegate = self
//            player.prepareToPlay()
//            player.play()
//        }
//        
//        
//    }
    
}
