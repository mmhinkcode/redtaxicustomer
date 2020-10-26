//
//  NotificationsViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/23/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!

    var array = [Dictionary<String, Any>]()

    override func viewWillAppear(_ animated: Bool)
    {
        self.getNotifications()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
        
        self.tableView.register(NotificationCell.self, forCellReuseIdentifier: "notification")
    }
    
    // MARK:- UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell

        //cell.imageView?.image = UIImage(named: "Ellipse 19")
        //cell.textLabel?.text = "Your driver is on his way"
        //cell.detailTextLabel?.text = "2 mins ago"

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 65))
        label.font = UIFont(name: "Poppins-Medium", size: 13)
        label.textAlignment = .center
        label.textColor = darkGrayColor
        label.text = "Today"
        
        return label
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        AppDelegate.sharedInstance.startApp()
    }
    
    func getNotifications()
    {
    }
}
