//
//  SettingsViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/18/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import KYDrawerController

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
    }
    
    // MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        cell.textLabel?.textColor = darkGrayColor
        
        switch indexPath.row
        {
        case 0:
            do
            {
                cell.imageView?.image = UIImage(named: "Group 1158")
                cell.textLabel?.text = "About us"
                
            }
            break
        case 1:
            do
            {
                cell.imageView?.image = UIImage(named: "Group 1157")
                cell.textLabel?.text = "Terms & Conditions"
                
            }
            break
        case 2:
            do
            {
                cell.imageView?.image = UIImage(named: "Group 1153")
                cell.textLabel?.text = "Privacy Policy"
                
            }
            break
        case 3:
            do
            {
                cell.imageView?.image = UIImage(named: "Group 1156")
                cell.textLabel?.text = "Rate Us"
                
            }
            break
        case 4:
            do
            {
                cell.imageView?.image = UIImage(named: "Group 1167")
                cell.textLabel?.text = "Contact Us"
                
            }
            break
        default: break
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK:- UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch indexPath.row
        {
        case 0:
            do
            {
                let editView = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                self.navigationController?.pushViewController(editView, animated: true)
            }
            break
        case 1:
            do
            {
                let editView = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                self.navigationController?.pushViewController(editView, animated: true)
            }
            break
        case 2:
            do
            {
                let editView = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                self.navigationController?.pushViewController(editView, animated: true)
            }
            break
        case 3:
            do
            {
                let editView = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                self.navigationController?.pushViewController(editView, animated: true)
            }
            break
        case 4:
            do
            {
                let editView = storyboard!.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                self.navigationController?.pushViewController(editView, animated: true)
            }
            break
        default: break
        }
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        AppDelegate.sharedInstance.startApp()
    }
}
