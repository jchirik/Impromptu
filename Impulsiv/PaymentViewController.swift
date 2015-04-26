//
//  PaymentViewController.swift
//  Impulsiv
//
//  Created by John Chirikjian on 4/12/15.
//  Copyright (c) 2015 Sinjin. All rights reserved.
//

import UIKit
import Foundation

class PaymentViewController: UIViewController, CardIOPaymentViewControllerDelegate {
    
    
    @IBOutlet var card_selected: UILabel!
    
    @IBOutlet var current_card_label: UILabel!
    @IBOutlet var add_card_button: UIButton!
    
    @IBOutlet var background_view: UIImageView!
    
    @IBOutlet var line_border: UIImageView!

    var redacted:String = ""
    
    
    @IBAction func menu_button_press(sender: AnyObject) {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }
    



    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        CardIOUtilities.preload()
        view.sendSubviewToBack(background_view)
        current_card_label.alpha = 0
        
        line_border.image = line_border.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        line_border.tintColor = UIColor(netHex:0x518FE6)
        
    }
    
    
    
    
    @IBAction func scanCard(sender: AnyObject) {
        var cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        //cardIOVC.navigationBarTintColor = UIColor.blackColor()
        
        cardIOVC.modalPresentationStyle = .FormSheet
        presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            println(info.cardNumber)
            println(info.expiryMonth)
            println(info.expiryYear)
            println(info.cvv)
            createToken(info)
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func createToken(cardInfo: CardIOCreditCardInfo!) {
        let card = STPCard()
        redacted = cardInfo.redactedCardNumber
        card.number = cardInfo.cardNumber
        card.expMonth = cardInfo.expiryMonth
        card.expYear = cardInfo.expiryYear
        card.cvc = cardInfo.cvv
        
        card_selected.text = cardInfo.redactedCardNumber
        current_card_label.alpha = 1
        add_card_button.setTitle("REPLACE CARD", forState: UIControlState.Normal)
        
        STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token: STPToken!, error: NSError!) -> Void in
            if error != nil {
                println("trouble processing payment")
            } else {
                self.handleToken(token)
            }
            
        })


    }
    
    func handleToken(token: STPToken!) {
        //send token to backend and create charge
        println("token created! time to send")
        
        
        println(token!)
        
        println("\(redacted)")
        
        var message:NSDictionary = ["token":"\(token)", "redacted":"\(redacted)"]
       socket.emit("stripe token", message)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}