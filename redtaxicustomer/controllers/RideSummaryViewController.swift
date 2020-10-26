//
//  RideSummaryViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/11/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class RideSummaryViewController: UIViewController
{
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var rideSummaryLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var rideTimeLabel: UILabel!
    @IBOutlet weak var waitTimeLabel: UILabel!
    @IBOutlet weak var distanceCrossedLabel: UILabel!
    @IBOutlet weak var baseFairLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var destinationAddressLabel: UILabel!
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var netTaxLabel: UILabel!
    @IBOutlet weak var finalFareLabel: UILabel!
    @IBOutlet weak var toBePaidLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        Functions.addCornerShadow(view: self.saveButton, cornerRadius: 20)

        self.doneButton.layer.masksToBounds = true
        self.doneButton.layer.cornerRadius = 22
    }
}
