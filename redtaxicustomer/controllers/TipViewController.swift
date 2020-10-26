//
//  TipViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/8/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class TipViewController: UIViewController
{
    @IBOutlet weak var tip1Button: UIButton!
    @IBOutlet weak var tip2Button: UIButton!
    @IBOutlet weak var tip3Button: UIButton!
    @IBOutlet weak var totalTipView: UIView!
    @IBOutlet weak var viewInvoiceButton: UIButton!
    @IBOutlet weak var rideTimeLabel: UILabel!
    @IBOutlet weak var distanceCrossedLabel: UILabel!
    @IBOutlet weak var totalTipLabel: UILabel!
    @IBOutlet weak var totalFareLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        Functions.addBorder(view: self.tip1Button, cornerRadius: 30, borderColor: lightGrayColor)
        Functions.addBorder(view: self.tip2Button, cornerRadius: 30, borderColor: lightGrayColor)
        Functions.addBorder(view: self.tip3Button, cornerRadius: 30, borderColor: lightGrayColor)

        self.viewInvoiceButton.layer.masksToBounds = true
        self.viewInvoiceButton.layer.cornerRadius = 22
    }
    
    @IBAction func onTip1Action(_ sender: Any)
    {
        self.selectTip(button: self.tip1Button)
        self.unselectTip(button: self.tip2Button)
        self.unselectTip(button: self.tip3Button)
    }
    
    @IBAction func onTip2Action(_ sender: Any)
    {
        self.unselectTip(button: self.tip1Button)
        self.selectTip(button: self.tip2Button)
        self.unselectTip(button: self.tip3Button)
    }
    
    @IBAction func onTip3Action(_ sender: Any)
    {
        self.unselectTip(button: self.tip1Button)
        self.unselectTip(button: self.tip2Button)
        self.selectTip(button: self.tip3Button)
    }
    
    func selectTip(button: UIButton)
    {
        button.backgroundColor = redColor
        let attributes = button.titleLabel?.attributedText?.mutableCopy() as! NSMutableAttributedString
        attributes.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributes.length))
        button.setAttributedTitle(attributes, for: .normal)
        Functions.addBorder(view: button, cornerRadius: 30, borderColor: redColor)
    }
    
    func unselectTip(button: UIButton)
    {
        button.backgroundColor = .white
        let attributes = button.titleLabel?.attributedText?.mutableCopy() as! NSMutableAttributedString
        attributes.addAttribute(NSAttributedString.Key.foregroundColor, value: lightGrayColor, range: NSRange(location: 0, length: attributes.length))
        button.setAttributedTitle(attributes, for: .normal)
        Functions.addBorder(view: button, cornerRadius: 30, borderColor: lightGrayColor)
    }
    
    @IBAction func showInvoice(_ sender: Any)
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RideSummaryViewController") as! RideSummaryViewController
        let root = UINavigationController(rootViewController: vc)
        AppDelegate.sharedInstance.window?.rootViewController = root
    }
}
