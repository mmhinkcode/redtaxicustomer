//
//  SideMenuViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/7/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import KYDrawerController

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var inButton: UIButton!
    @IBOutlet weak var twButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.fbButton.layer.masksToBounds = true
        self.fbButton.layer.cornerRadius = 16
        
        self.inButton.layer.masksToBounds = true
        self.inButton.layer.cornerRadius = 16
        
        self.twButton.layer.masksToBounds = true
        self.twButton.layer.cornerRadius = 16
    }
    
    // MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableCell?

        switch indexPath.row
        {
        case 0:
            do
            {
                cell?.titleLabel?.text = "Promotions"
            }
            break
        case 1:
            do
            {
                cell?.titleLabel?.text = "Notifications"
            }
            break
        case 2:
            do
            {
                cell?.titleLabel?.text = "My Rides"
            }
            break
        case 3:
            do
            {
                cell?.titleLabel?.text = "Fare"
            }
            break
        case 4:
            do
            {
                cell?.titleLabel?.text = "Help"
            }
            break
        case 5:
            do
            {
                cell?.titleLabel?.text = "Settings"
            }
            break
        case 6:
            do
            {
                cell?.titleLabel?.text = "Log out"
                cell?.titleLabel.font = UIFont(name: "Poppins-Medium", size: 15)
                cell?.titleLabel.textColor = redColor
            }
            break
        default: break
        }
        
        return cell!
    }
    
    // MARK:- UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let elDrawer = self.navigationController?.parent as? KYDrawerController
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch indexPath.row
        {
        case 0:
            do
            {
                let centerViewController = storyBoard.instantiateViewController(withIdentifier: "PromotionsViewController") as! PromotionsViewController
                elDrawer!.mainViewController = UINavigationController(
                    rootViewController: centerViewController
                )
            }
            break
        case 1:
            do
            {
                let centerViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
                elDrawer!.mainViewController = UINavigationController(
                    rootViewController: centerViewController
                )
            }
            break
        case 2:
            do
            {
                let centerViewController = storyBoard.instantiateViewController(withIdentifier: "MyRidesViewController") as! MyRidesViewController
                elDrawer!.mainViewController = UINavigationController(
                    rootViewController: centerViewController
                )
            }
            break
        case 3:
            do
            {
                let centerViewController = storyBoard.instantiateViewController(withIdentifier: "FareViewController") as! FareViewController
                elDrawer!.mainViewController = UINavigationController(
                    rootViewController: centerViewController
                )
            }
            break
        case 4:
            do
            {
                let centerViewController = storyBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                elDrawer!.mainViewController = UINavigationController(
                    rootViewController: centerViewController
                )
            }
            break
        case 5:
            do
            {
                let centerViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                elDrawer!.mainViewController = UINavigationController(
                    rootViewController: centerViewController
                )
            }
            break
        case 6:
            do
            {
            
            }
            break
        default: break
        }
        elDrawer?.setDrawerState(.closed, animated: true)
    }
}
