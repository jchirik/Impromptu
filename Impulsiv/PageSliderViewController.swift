//
//  ContainerViewController.swift
//  Impulsiv
//
//  Created by John Chirikjian on 3/29/15.
//  Copyright (c) 2015 Sinjin. All rights reserved.
//

import UIKit
import Foundation




//var establishmentNames: Array<String> = ["Shake Shack", "Anaya Sushi", "Pepes Pizza"]
//
//var dealNames: Array<String> = ["Shackburger, French Fries", "All You Can Eat Sushi", "Large Cheese Pizza"]
//
//var ratings: Array<Double> = [2.0, 4.0, 3.6]
//
//var deal_old_prices: Array<Double> = [14.99, 29.99, 12.99]
//
//var deal_new_prices: Array<Double> = [9.99, 19.99, 7.99]
//
//var deal_pics: Array<UIImage> = []
//
//var latitudes: Array<Double> = [43.0, 23.0, 32.0]
//
//var longitudes: Array<Double> = [43.0, 23.0, 32.0]
//
//var deal_colors: Array<Int> = [9162635, 16764159, 3355520]




var dealIDArray:Array<String> = []
var dealMax:Array<Double> = []
var dealMin:Array<Double> = []

var latitudes: Array<Double> = []
var longitudes: Array<Double> = []
var establishmentNames: Array<String> = []
var establishmentHours: Array<String> = []
var dealNames: Array<String> = []
var dealDescriptions: Array<String> = []
var ratings: Array<Double> = []
var deal_old_prices: Array<Double> = []
var deal_pics: Array<UIImage> = []
var deal_colors: Array<Int> = []
var deal_times: Array<NSDate> = []






class PageSliderViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController?
    
    
    @IBAction func menu_button(sender: AnyObject) {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }


    

    
    var currentIndex : Int = 0
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        

        
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController: DealViewController = viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        pageViewController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: false, completion: nil)
        

        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        view.sendSubviewToBack(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    


    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! DealViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! DealViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == establishmentNames.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> DealViewController?
    {
        if establishmentNames.count == 0 || index >= establishmentNames.count
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("deals") as! DealViewController
        
        pageContentViewController.deal_ID = dealIDArray[index]
        pageContentViewController.establishment = establishmentNames[index]
        pageContentViewController.deal = dealNames[index]
        pageContentViewController.rating = ratings[index]
        pageContentViewController.deal_old_price = deal_old_prices[index]
        pageContentViewController.deal_min_new = dealMin[index]
        pageContentViewController.deal_max_new = dealMax[index]
        pageContentViewController.deal_pic = deal_pics[index]
        pageContentViewController.deal_color = deal_colors[index]
        
        pageContentViewController.tagline = dealDescriptions[index]
        pageContentViewController.hours = establishmentHours[index]
        
        pageContentViewController.long = longitudes[index]
        pageContentViewController.lat = latitudes[index]
        
        pageContentViewController.dealtime = deal_times[index]

        
        
        
        pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}