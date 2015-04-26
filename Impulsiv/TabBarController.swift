//
//  TabBarController.swift
//  FrostedSidebar
//
//  Created by Evan Dekhayser on 8/28/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
	
	var sidebar: FrostedSidebar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		tabBar.hidden = true
		
		moreNavigationController.navigationBar.hidden = true
		
		sidebar = FrostedSidebar(itemImages: [
			UIImage(named: "deals")!,
			UIImage(named: "claimed")!,
			UIImage(named: "payment")!,
			UIImage(named: "settings")!,
            UIImage(named: "logout")!],
			colors: [
				UIColor.whiteColor(),
                UIColor.whiteColor(),
                UIColor.whiteColor(),
                UIColor.whiteColor(),
                UIColor.whiteColor()],
            
			selectedItemIndices: NSIndexSet(index: 0))
		
		sidebar.isSingleSelect = true
		sidebar.actionForIndex = [
			0: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 0}) },
			1: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 1}) },
            2: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 2}) },
            3: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 3}) },
            4:{
            self.performSegueWithIdentifier("logout", sender: self)
            println("logged out!")
            }
        ]
	}
	
}
