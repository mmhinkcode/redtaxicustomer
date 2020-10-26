//
//  SavedPlacesViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/12/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class SavedPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var array = [Dictionary<String, Any>]()

    override func viewWillAppear(_ animated: Bool)
    {
        self.getAllAddresses()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
        
        self.tableView.register(UINib(nibName: "AddressTableCell", bundle: nil), forCellReuseIdentifier: "AddressTableCell")
        let headerView = UIView(frame: CGRect.zero)
        let footerView = UIView(frame: CGRect.zero)
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView

    }
    
    // MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableCell", for: indexPath) as! AddressTableCell

        let dic = self.array[indexPath.row] as [String: Any]

        switch dic["address_type"]! as! String
        {
        case "home":
            do
            {
                cell.addressImageView.image = UIImage(named: "Group 1281")
            }
            break
        case "work":
            do
            {
                cell.addressImageView.image = UIImage(named: "Group 1280")
            }
            break
        case "gym":
            do
            {
                cell.addressImageView.image = UIImage(named: "Group 1196")
            }
            break
        default:
            do
            {
                cell.addressImageView.image = UIImage(named: "Group 1283")
            }
            break
        }
        cell.addressTitleLabel.text = dic["address_name"] as? String
        cell.addressDescriptionLabel.text = dic["address"] as? String
        
        return cell
    }
    
    // MARK:- UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let dic = self.array[indexPath.row]
            self.deleteAddress(address_id: dic["id"] as! Int)
            self.array.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAllAddresses()
    {
        ApiController.sharedInstance.getAllAddresses(completionHandler: { (data, error) -> Void in
            if error == nil
            {
                self.array = data?.value(forKey: "data") as! [Dictionary<String, Any>]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func deleteAddress(address_id: Int)
    {
        ApiController.sharedInstance.deleteAddress(address_id: address_id, completionHandler: { (data, error) -> Void in
            if error == nil
            {
            }
        })
    }
}
