//
//  RideTableCell.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/14/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import Foundation

import UIKit
import QuartzCore

class RideTableCell: UITableViewCell
{
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var upcomingView: UIView!
    @IBOutlet weak var topRightLabel: UILabel!
    @IBOutlet weak var scheduledTimeLabel: UILabel!
    @IBOutlet weak var bottomRightLabel: UILabel!
    @IBOutlet weak var bottomRightValueLabel: UILabel!

    var isUpcoming = false

    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        
        self.shadowView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.shadowView.layer.shadowRadius = 2.0
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOpacity = 1.0
        
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 20

    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func set(upcoming: Bool)
    {
        self.isUpcoming = upcoming
        self.topRightLabel.isHidden = self.isUpcoming
        self.completedView.isHidden = self.isUpcoming
        self.upcomingView.isHidden = !self.isUpcoming
        if self.isUpcoming
        {
            self.bottomRightLabel.text = "Scheduled Date"
        }
        else
        {
            self.bottomRightLabel.text = "Total"
        }
    }
}
