//
//  ContactUsViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/22/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController
{
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
