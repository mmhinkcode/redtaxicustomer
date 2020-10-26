//
//  PaymentMethodsViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/31/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class PaymentMethodsViewController: UIViewController
{
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
