//
//  ViewController.swift
//  Impulsiv
//
//  Created by John Chirikjian on 3/27/15.
//  Copyright (c) 2015 Sinjin. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation



// SET THESE VARIABLES via database
//var establishment:String = "SHAKE SHACK"
//var deal:String = "SHACKBURGER + FRENCH FRIES"
//var rating:Double = 2.0
//var deal_old_price:Double = 14.99
//var deal_new_price:Double = 9.99
//var deal_pic_name:String = "shake_shack_image.jpg"
//
//var deal_color = 0xfc9644







var claimedDealCharge:Int = 0
var claimedDealDescription:String = ""



// Turn HEX into UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class DealViewController: UIViewController {
    
    
    
    
    // MAIN VARIBALES
    
    var pageIndex : Int = 0
    
    var deal_ID:String = ""
    var establishment:String = "SHAKE SHACK"
    var deal:String = "SHACKBURGER + FRENCH FRIES"
    var rating:Double = 4.3
    var deal_old_price:Double = 14.99
    
    var deal_max_new:Double = 0.00
    var deal_min_new:Double = 0.00
    
    var deal_new_price:Double = 9.99
    var deal_pic:UIImage? = nil
    var deal_color = 0
    
    var tagline = ""
    var hours = ""
    
    var long = 0.0
    var lat = 0.0
    
    var dealtime:NSDate? = nil
    
    

    var detailedViewMode = false
    
    var annotate = MKPointAnnotation()
    
    
    @IBAction func claim_deal(sender: AnyObject) {
        
        var message1:NSDictionary = ["_id":"\(deal_ID)"]
        socket.emit("claim deal", message1)

        println("deal claimed!")
    }
    
    
    

    
    @IBOutlet var deal_tagline: UILabel!
    @IBOutlet var establishment_times: UILabel!
    
    
    @IBOutlet var deal_image: UIImageView!
    @IBOutlet var gradient_image: UIImageView!
    

    @IBOutlet var claim_button: UIButton!
    @IBOutlet var claim_label: UILabel!
    @IBOutlet var old_price: UILabel!
    @IBOutlet var new_price: UILabel!
    

    @IBOutlet var remaining_time1: UILabel!
    @IBOutlet var remaining_time2: UILabel!
    
    @IBOutlet var valid_time: UILabel!
    
    var screen_height:CGFloat = 0
    var pull_thresh:CGFloat = 6/7
    var absolute_min:CGFloat = 0
    
    @IBOutlet var draggable_view: UIView!
    @IBOutlet var map_view: MKMapView!
    
    

    
    func update_stars(stars:Double, i:Int, view:ContainerViewController) {
        if i <= 5 {
            
            var current_star: UIImageView
            var mutable_stars = stars
            
            if i == 1 {
                current_star = view.star1
            } else if i == 2 {
                current_star = view.star2
            } else if i == 3 {
                current_star = view.star3
            } else if i == 4 {
                current_star = view.star4
            } else {
                current_star = view.star5
            }
            
            if mutable_stars >= 1 {
                current_star.image = UIImage(named: "star_filled.png")
                mutable_stars = mutable_stars - 1
            } else if mutable_stars >= 0.5 {
                current_star.image = UIImage(named: "star_half_fill.png")
                mutable_stars = mutable_stars - 0.5
            } else {
                current_star.image = UIImage(named: "star_unfilled.png")
            }
            
            
            current_star.image = current_star.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            current_star.tintColor = UIColor(netHex:deal_color)
            
            update_stars(mutable_stars, i: i+1, view:view)
        }
    }
    
    func updateTime()
    {
        let time = Int(floor(dealtime!.timeIntervalSinceNow))
        if time >= 3600 {
            let hours = time/3600
            let minutes = (time%3600)/60
            remaining_time1.text = "\(hours) HOURS"
            remaining_time2.text = "\(minutes) MINUTES"
            
        } else if time >= 0 {
            let minutes = time/60
            let seconds = (time%60)
            remaining_time1.text = "\(minutes) MINUTES"
            remaining_time2.text = "\(seconds) SECONDS"
            
        } else {
            remaining_time1.text = "DEAL"
            remaining_time2.text = "ENDED"
        }

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        deal_tagline.text = tagline
        establishment_times.text = "OPEN TODAY" + hours
        
        deal_new_price = deal_min_new
        claimedDealCharge = Int(deal_min_new*100)
        claimedDealDescription = establishment
        
        // attributed text line spacing
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.maximumLineHeight = 44
        
        let attrString = [NSParagraphStyleAttributeName : paragraphStyle]

        
        var latDelta:CLLocationDegrees = 0.005
        var longDelta:CLLocationDegrees = 0.005
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat as CLLocationDegrees, long as CLLocationDegrees)
        
        annotate.title = nil
        annotate.coordinate = location
        
        map_view.setRegion(MKCoordinateRegionMake(location, span), animated: false)
        map_view.addAnnotation(annotate)
        
        
        // Set container variables
        
        let childView = self.childViewControllers[0] as! ContainerViewController
        
        childView.establishment_name.text = establishment
        
        
        childView.deal_line.attributedText = NSAttributedString(string: "\n" + deal, attributes:attrString)
        childView.deal_line.textColor = UIColor(netHex:deal_color)
        childView.second_border.tintColor = UIColor(netHex:deal_color)

        var stars = min(round(rating * 2.0)/2.0, 5.0)
        update_stars(stars, i: 1, view: childView)

        
        // repeat every second
        
        
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            self.updateTime()
            var updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        })
        
        
        


        deal_image.image = deal_pic
  
        
        claim_button.backgroundColor = UIColor.whiteColor()
        claim_button.layer.cornerRadius = 5
        claim_button.layer.borderWidth = 2
        claim_button.layer.borderColor = UIColor(netHex:deal_color).CGColor
        
        
        

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        screen_height = self.view.bounds.height
        
        
        
        
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$\(deal_old_price)")
        
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        
        old_price.attributedText = attributeString
        
        
        new_price.text = "$\(deal_new_price)"
        
//        var sublayer = CALayer()
//        sublayer.backgroundColor = UIColor.blackColor().CGColor
//        sublayer.frame = CGRectMake(0, deal_image.frame.size.height, deal_image.bounds.size.width, 5);
//        deal_image.layer.addSublayer(sublayer)

        
        view.sendSubviewToBack(draggable_view)
        view.sendSubviewToBack(gradient_image)
        view.sendSubviewToBack(deal_image)
        
        self.view.addConstraint(NSLayoutConstraint(item: deal_image, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -325))
        
        self.view.addConstraint(NSLayoutConstraint(item: draggable_view, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 1, constant: 0))
        
        map_view.alpha = 0
        establishment_times.alpha = 0
        deal_tagline.alpha = 0
        pull_thresh = 6/7
        
        var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        draggable_view.addGestureRecognizer(gesture)
        draggable_view.userInteractionEnabled = true
    
        
        
    }
    
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        
        let translation = gesture.translationInView(self.view)
        var label = gesture.view!
        
        absolute_min = max(label.center.y, absolute_min)
        
        let y_translation = min(max(label.center.y+translation.y, screen_height/2), absolute_min)
        
        
        label.center = CGPoint(x: label.center.x, y: y_translation)
        
        deal_image.center = CGPoint(x: deal_image.center.x, y: min(screen_height/4, deal_image.center.y+translation.y/16))
        
        
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        let object_opacity = (label.center.y - screen_height/2)/(screen_height/2)
        
//        remaining_time1.alpha = object_opacity
//
//        remaining_time2.alpha = object_opacity
//        valid_time.alpha = object_opacity
        
        if (detailedViewMode) {
            map_view.alpha = max(1-(object_opacity*12), 0)
            establishment_times.alpha = max(1-(object_opacity*12), 0)
            deal_tagline.alpha = max(1-(object_opacity*12), 0)
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if label.center.y < screen_height*pull_thresh {
                // go to top of screen
                UIView.animateWithDuration(0.5, animations: { () -> Void in
//                    self.remaining_time1.alpha = 0
//                    self.remaining_time2.alpha = 0
//                    self.valid_time.alpha = 0
                    self.map_view.alpha = 1
                    self.establishment_times.alpha = 1
                    self.deal_tagline.alpha = 1
                    self.claim_button.backgroundColor = UIColor(netHex:self.deal_color)
                    self.claim_label.textColor = UIColor.whiteColor()
                    self.old_price.textColor = UIColor.whiteColor()
                    self.new_price.textColor = UIColor.whiteColor()
                    
                    label.center = CGPoint(x: self.view.bounds.width/2, y: self.screen_height/2)
                    self.deal_image.center = CGPoint(x: self.view.bounds.width/2, y: self.screen_height/4-self.screen_height/16)
                    
                    }, completion: { (worked) -> Void in
                        self.pull_thresh = 4/7
                        self.detailedViewMode = true
                        //self.deal_image.center = CGPoint(x: self.deal_image.center.x, y: self.screen_height*7/32)
                })
            } else {
                // go to middle of screen
                UIView.animateWithDuration(0.5, animations: { () -> Void in
//                    self.remaining_time1.alpha = 1
//                    self.remaining_time2.alpha = 1
//                    self.valid_time.alpha = 1
                    label.center = CGPoint(x: self.view.bounds.width/2, y: self.screen_height+(self.screen_height/2)-325)
                    self.deal_image.center = CGPoint(x: self.view.bounds.width/2, y: (self.screen_height-325)/2)
                    
                    self.claim_button.backgroundColor = UIColor.whiteColor()
                    self.claim_label.textColor = UIColor.blackColor()
                    self.old_price.textColor = UIColor.blackColor()
                    self.new_price.textColor = UIColor.blackColor()
                })
                map_view.alpha = 0
                establishment_times.alpha = 0
                deal_tagline.alpha = 0
                pull_thresh = 6/7
                detailedViewMode = false
                
            }

        }
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

