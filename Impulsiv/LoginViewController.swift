//
//  LoginViewController.swift
//  Impulsiv
//
//  Created by John Chirikjian on 4/12/15.
//  Copyright (c) 2015 Sinjin. All rights reserved.
//

import UIKit
import Foundation


let socket = SocketIOClient(socketURL: "52.5.181.69:8080")
var savedRedactedCard = ""

class LoginViewController: UIViewController {

        @IBOutlet var black_cube: UIImageView!
    @IBOutlet var member_logged_label: UILabel!
    @IBOutlet var change_button: UIButton!
    @IBOutlet var submit_button: UIButton!
    
    
    
    
    
    
    @IBOutlet var email_label: UILabel!
    @IBOutlet var email_box: UITextField!
    @IBOutlet var password_box: UITextField!
    
    
    var email_placement: NSLayoutConstraint? = nil
    
    
    var registered:Bool = true
    
    
    func addHandlers() {
        
        socket.onAny {
            println("got event: \($0.event) with items \($0.items)")
        }
        
        socket.on("connect") { data, ack in
            println("connected")
        }
        
        
        socket.on("claim deal succeed", callback: { (data, ack) -> Void in
            var message2:NSDictionary = ["amount":claimedDealCharge, "description":"\(claimedDealDescription)"]
            socket.emit("stripe charge", message2)
        })
        
        
        socket.on("deals") { data, ack in
            
            
            for deal in (data![0] as! NSArray) {
                
                var hexcolor = strtoul(deal["color"] as! String, nil, 16)
                
                dealIDArray.append(deal["_id"] as! String)
                
                latitudes.append(deal["businesslatitude"] as! Double)
                longitudes.append(deal["businesslongitude"] as! Double)
                
                establishmentHours.append(deal["businesshours"] as! String)
                establishmentNames.append(deal["businessname"] as! String)
                
                deal_colors.append(Int(hexcolor))
                
                dealDescriptions.append(deal["dealdescription"] as! String)
                
                dealNames.append(deal["dealname"] as! String)
                
                dealMax.append(deal["maxprice"] as! Double)
                dealMin.append(deal["minprice"] as! Double)
                deal_old_prices.append(deal["oldprice"] as! Double)
                
                ratings.append(deal["rating"] as! Double)

                
                let formatter = NSDateFormatter()
                formatter.locale = NSLocale(localeIdentifier: "US_en")
                formatter.dateFormat = "dd MM yyyy HH:mm:ss Z"
                let date = formatter.dateFromString("26 04 2015 18:01:12 +0000")
            
                deal_times.append(date!)
                
                let url = NSURL(string: deal["photo"] as! String)
                
                
                //let url = NSURL(string: "http://www.kazusono.com/flash/slides/Kazu-Sushi-Bar-Japanese-Restaurant-Norwalk-12.jpg")
                let req = NSURLRequest(URL: url!)
                
                var imageError: NSError?
                
                let imagedata = NSURLConnection.sendSynchronousRequest(req, returningResponse: nil, error: &imageError)
                
                if imageError != nil {
                    let imageprob = deal["businessname"] as! String
                    println("there was an error with image for \(imageprob)")
                } else {
                    let image = UIImage(data: imagedata!)
                    deal_pics.append(image!)
                }
                
//                NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: {
//                    response, data, error in
//                    
//                    if error != nil {
//                        println("There was an error")
//                    } else {
//                        let image = UIImage(data: data)
//                        deal_pics.append(image!)
//                    }
//                    
//                })
                
                
            }
            
            println(establishmentNames)
            
            self.performSegueWithIdentifier("loggedIn", sender: self)

        }
        
        
    }

    
    @IBAction func loggedIn(sender: AnyObject) {
    
        
        socket.on("customer register succeed") { data, ack in
            socket.emit("deals")
        }
        socket.on("customer login succeed") { data, ack in
            //let userArr = data![0] as! NSArray
            //println(userArr[3])
            socket.emit("deals")
        }

        
        
        if (registered) {
            var message:NSDictionary = ["email": "jchirik@gmail.com", "password": "test"]
            socket.emit("customer login", message)
        } else {
            var message:NSDictionary = ["email": "jchirik@gmail.com", "password": "test", "firstname": "John", "lastname": "Appleseed"]
            socket.emit("customer register", message)
        }
        
    }
    
    @IBAction func changeRegister(sender: AnyObject) {
        if (registered) {
            
            //self.view.removeConstraint(email_placement!)
            
  
            UIView.animateWithDuration(3.0, animations: { () -> Void in
                self.email_placement!.constant = 200
            })
            
            //self.view.addConstraint(self.email_placement!)

            
            
            submit_button.setTitle("REGISTER", forState: UIControlState.Normal)
            submit_button.backgroundColor = UIColor(netHex:0xff0000)

            change_button.setTitle("LOG IN", forState: UIControlState.Normal)
            change_button.setTitleColor(UIColor(netHex:0xf9b72c), forState: UIControlState.Normal)
            
            
            member_logged_label.text = "HAVE AN ACCOUNT?"
            
            registered = false
        } else {
            submit_button.setTitle("LOG IN", forState: UIControlState.Normal)
            submit_button.backgroundColor = UIColor(netHex:0xf9b72c)
            
            change_button.setTitle("REGISTER", forState: UIControlState.Normal)
            change_button.setTitleColor(UIColor(netHex:0xff0000), forState: UIControlState.Normal)
            
            member_logged_label.text = "NOT A MEMBER?"
            registered = true
        }
        
    }
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // test connection
        
        addHandlers()
        socket.connect()
        
        println("connecting")
        
        email_placement = NSLayoutConstraint(item: email_label, attribute: .Top, relatedBy: .Equal, toItem: black_cube, attribute: .Bottom, multiplier: 1, constant: 35)
        
        
        
        self.view.addConstraint(email_placement!)
        
        
        registered = true
        
        self.view.addConstraint(NSLayoutConstraint(item: black_cube, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 0.5, constant: 0))
        
    
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // hide keyboard when screen is pressed
//    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.view.endEditing(true)
//    }
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
}