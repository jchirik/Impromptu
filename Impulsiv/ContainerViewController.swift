//
//  ContainerViewController.swift
//  Impulsiv
//
//  Created by John Chirikjian on 3/29/15.
//  Copyright (c) 2015 Sinjin. All rights reserved.
//

import UIKit
import Foundation


class ContainerViewController: UIViewController {
    
    @IBOutlet var establishment_name: UILabel!
    
    @IBOutlet var deal_line: UILabel!
    
    @IBOutlet var star1: UIImageView!
    @IBOutlet var star2: UIImageView!
    @IBOutlet var star3: UIImageView!
    @IBOutlet var star4: UIImageView!
    @IBOutlet var star5: UIImageView!
    
    @IBOutlet var second_border: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
//        establishment_name.text = establishment
//        deal_line.text = deal
//        deal_line.textColor = UIColor(netHex:deal_color)
        
        second_border.image = second_border.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//        second_border.tintColor = UIColor(netHex:deal_color)
        
//        var stars = min(round(rating * 2.0)/2.0, 5.0)
//        update_stars(stars, i: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}