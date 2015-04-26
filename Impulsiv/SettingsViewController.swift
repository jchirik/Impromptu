//
//  SettingsViewController.swift
//  Impulsiv
//
//  Created by John Chirikjian on 4/12/15.
//  Copyright (c) 2015 Sinjin. All rights reserved.
//

import UIKit
import Foundation


class SettingsViewController: UIViewController {
    
    
    @IBAction func menu_button_press(sender: AnyObject) {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}