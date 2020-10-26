//
//  DestinationIconView.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/26/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class DestinationIconView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var containerView: UIView!

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("DestinationIconView", owner: self, options: nil)
        addSubview(self.contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth]
        
        Functions.addCornerShadow(view: self.containerView, cornerRadius: 5)
        Functions.addCornerShadow(view: self.durationView, cornerRadius: 5)
    }
}
