//
//  StarViewController.swift
//  Roamni
//
//  Created by Zihao Wang on 27/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import UIKit

class StarViewController: UIView,RatingBarDelegate{
    var rating: CGFloat = 4 {
        didSet{
                        self.setNeedsLayout()
        }
    }
        var ratingMax: CGFloat = 5//总数值,必须为numStars的倍数
        var numStars: Int = 5 //星星总数
        var canAnimation: Bool = false//是否开启动画模式
        var animationTimeInterval: TimeInterval = 0.2//动画时间
        var incomplete:Bool = true//评分时是否允许不是整颗星星
        var isIndicator:Bool = true//RatingBar是否是一个指示器（用户无法进行更改）
        
        var imageLight: UIImage = UIImage(named: "ic_ratingbar_star_light")!
        var imageDark: UIImage = UIImage(named: "ic_ratingbar_star_dark")!
        
        var foregroundRatingView: UIView!
        var backgroundRatingView: UIView!

        var isDrew = false
    
        func ratingDidChange(ratings: CGFloat)
        {
         self.rating = ratings
         print(self.rating)
            
    }

    
        func buildView(){
            if isDrew {return}
            isDrew = true
            //创建前后两个View，作用是通过rating数值显示或者隐藏“foregroundRatingView”来改变RatingBar的星星效果
            self.backgroundRatingView = self.createRatingView(imageDark)
            self.foregroundRatingView = self.createRatingView(imageLight)
            animationRatingChange()
            self.addSubview(self.backgroundRatingView)
            self.addSubview(self.foregroundRatingView)
            
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            buildView()
            let animationTimeInterval = self.canAnimation ? self.animationTimeInterval : 0
            //开启动画改变foregroundRatingView可见范围
            UIView.animate(withDuration: animationTimeInterval, animations: {self.animationRatingChange()})
        }
        //改变foregroundRatingView可见范围
        func animationRatingChange(){
            let realRatingScore = self.rating / self.ratingMax
            self.foregroundRatingView.frame = CGRect(x: 0, y: 0,width: self.bounds.size.width * realRatingScore, height: self.bounds.size.height)
            
        }
        //根据图片名，创建一列RatingView
        func createRatingView(_ image: UIImage) ->UIView{
            let view = UIView(frame: self.bounds)
            view.clipsToBounds = true
            view.backgroundColor = UIColor.clear
            //开始创建子Item,根据numStars总数
            for position in 0 ..< numStars{
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: CGFloat(position) * self.bounds.size.width / CGFloat(numStars), y: 0, width: self.bounds.size.width / CGFloat(numStars), height: self.bounds.size.height)
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                view.addSubview(imageView)
            }
            return view
            
        }
}
protocol RatingBarDelegate{
    func ratingDidChange(ratings: CGFloat)
}

