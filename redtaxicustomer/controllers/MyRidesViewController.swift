//
//  MyRidesViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/14/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import KYDrawerController

class MyRidesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var upcomingButton: UIButton!

    var array = [Dictionary<String, Any>]()
    var isUpcoming = false
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getRides()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        Functions.addCornerShadow(view: self.menuButton, cornerRadius: 20)
        Functions.addLeftCorner(view: self.completedButton, cornerRadius: 20)
        Functions.addRightCorner(view: self.upcomingButton, cornerRadius: 20)

        let headerView = UIView(frame: CGRect.zero)
        let footerView = UIView(frame: CGRect.zero)
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView

    }
    
    // MARK:- UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideTableCell") as! RideTableCell?
        
        cell!.set(upcoming: self.isUpcoming)
        if self.isUpcoming
        {
            cell!.scheduledTimeLabel.text = "5:30 PM"
            cell!.bottomRightValueLabel.text = "Wdnesday 12.01.2020"
        }
        else
        {
            cell!.bottomRightValueLabel.text = "52.000 LBP"
        }
        
        return cell!
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Action here
        // In case of delete, you can simply do:
        if editingStyle == .delete {
            //Remove item at relative position from datasource array
            //Reload tableview at the respective indexpath
        }
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            //YOUR_CODE_HERE
        }
        editAction.image = UIImage(named: "edit")
        editAction.backgroundColor = .white
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            //YOUR_CODE_HERE
        }
        deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = .white
        let configuration = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        AppDelegate.sharedInstance.startApp()
    }
    
    @IBAction func onCompletedAction(_ sender: Any)
    {
        self.isUpcoming = false
        self.completedButton.backgroundColor = redColor
        self.completedButton.setTitleColor(.white, for: .normal)
        self.upcomingButton.backgroundColor = darkWhiteColor
        self.upcomingButton.setTitleColor(darkGrayColor, for: .normal)
        self.tableView.reloadData()
    }
    
    @IBAction func onUpComingAction(_ sender: Any)
    {
        self.isUpcoming = true
        self.completedButton.backgroundColor = darkWhiteColor
        self.completedButton.setTitleColor(darkGrayColor, for: .normal)
        self.upcomingButton.backgroundColor = redColor
        self.upcomingButton.setTitleColor(.white, for: .normal)
        self.tableView.reloadData()
    }
    
    func getRides()
    {
    }
}
