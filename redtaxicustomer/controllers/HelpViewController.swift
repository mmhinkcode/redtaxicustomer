//
//  HelpViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/24/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!

    var array = [Dictionary<String, Any>]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
        
        self.tableView.register(HelpCell.self, forCellReuseIdentifier: "help")
    }
    
    // MARK:- UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 2
        }
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCell", for: indexPath) as! HelpCell

        //cell.imageView?.image = UIImage(named: "Ellipse 19")
        //cell.textLabel?.text = "Your driver is on his way"
        //cell.detailTextLabel?.text = "2 mins ago"
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell.textLabel?.text = "What are Red’s rates?"
            }
            else
            {
                cell.textLabel?.text = "Why am i being charged a cancellation fee?"
            }
        }
        else
        {
            switch indexPath.row
            {
            case 0:
                do
                {
                    cell.textLabel?.text = "Your payments & receipts"
                }
                break
            case 1:
                do
                {
                    cell.textLabel?.text = "Safety & Security"
                }
                break
            case 2:
                do
                {
                    cell.textLabel?.text = "Your bookings"
                }
                break
            case 3:
                do
                {
                    cell.textLabel?.text = "Your guide to Red"
                }
                break
            default:
                break
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 62))
        let label = UILabel(frame: CGRect(x: 20, y: view.frame.size.height-19-17, width: view.frame.size.width-2*20, height: 19))
        label.font = UIFont(name: "Poppins-SemiBold", size: 13)
        label.textColor = darkGrayColor
        if section == 0
        {
            label.text = "QUICK HELP"
        }
        else
        {
            label.text = "MORE HELP TOPICS"
        }
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.section == 0
        {
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
            default: break
            }
        }
        else
        {
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
            default: break
            }
        }
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        AppDelegate.sharedInstance.startApp()
    }
}
