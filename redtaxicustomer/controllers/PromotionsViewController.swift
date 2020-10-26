//
//  PromotionsViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/24/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class PromotionsViewController: UIViewController
{
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var redeemView: UIView!
    @IBOutlet weak var redeemButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
        Functions.addCornerShadow(view: self.redeemView, cornerRadius: 10)
        Functions.addCornerShadow(view: self.redeemButton, cornerRadius: 15)
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        AppDelegate.sharedInstance.startApp()
    }
}

