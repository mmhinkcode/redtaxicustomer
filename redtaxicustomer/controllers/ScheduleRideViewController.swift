//
//  ScheduleRideViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/11/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class ScheduleRideViewController: UIViewController
{
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLayoutSubviews()
    {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.containerView.frame
        rectShape.position = self.containerView.center
        rectShape.path = UIBezierPath(roundedRect: self.containerView.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 40, height: 40)).cgPath
         self.containerView.layer.backgroundColor = UIColor.white.cgColor
         self.containerView.layer.mask = rectShape
        
        Functions.addCornerShadow(view: self.confirmButton, cornerRadius: 23)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Functions.addTopCorner(view: self.containerView, cornerRadius: 20)
    }
    
    @IBAction func onConfirmAction(_ sender: Any)
    {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm a"
        AppDelegate.sharedInstance.ride_date = df.string(from: self.datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
}
