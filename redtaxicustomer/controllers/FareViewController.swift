//
//  FareViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/14/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import KYDrawerController

class FareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var array = [Dictionary<String, Any>]()

    override func viewWillAppear(_ animated: Bool)
    {
        self.getFares()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        Functions.addCornerShadow(view: self.menuButton, cornerRadius: 20)
        
        let headerView = UIView(frame: CGRect.zero)
        let footerView = UIView(frame: CGRect.zero)
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView

    }
    
    // MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FareTableCell") as! FareTableCell?

        return cell!
    }
    
    @IBAction func onMenuAction(_ sender: Any)
    {
        AppDelegate.sharedInstance.startApp()
    }
    
    func getFares()
    {
        ApiController.sharedInstance.getFares(completionHandler: { (data, error) -> Void in
            if error == nil
            {
                self.array = data?.value(forKey: "data") as! [Dictionary<String, Any>]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
}
