//
//  CustomInfoWindow.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/19/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

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
        Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)
        addSubview(self.contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth]
    }
}
