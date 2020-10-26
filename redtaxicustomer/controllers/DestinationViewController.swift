//
//  DestinationViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/11/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import GooglePlaces

class DestinationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    
    var flag = "destination"
    var array = [Dictionary<String, Any>]()
    var searchArray = [GMSAutocompletePrediction]()
    var placesClient = GMSPlacesClient()
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getAllAddresses()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.destinationTextField.becomeFirstResponder()
        Functions.addInputAccessoryView(textField: self.destinationTextField, frame: self.view.frame)
                
        if(self.flag == "destination")
        {
            self.titleLabel.text = "DESTINATION LOCATION"
            self.locationLabel.text = "Destination Location"
            self.imageView.image = UIImage(named: "Group 877")
            self.destinationTextField.placeholder = "Where are you heading to ?"
        }
        else
        {
            self.titleLabel.text = "PICKUP LOCATION"
            self.locationLabel.text = "pickup Location"
            self.imageView.image = UIImage(named: "Group 8")
            self.destinationTextField.placeholder = "Where do we pick you from ?"
        }
        
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
        Functions.addCornerShadow(view: self.destinationView, cornerRadius: 5)
        Functions.addCornerShadow(view: self.stopButton, cornerRadius: 5)
        
        self.tableView.register(UINib(nibName: "AddressTableCell", bundle: nil), forCellReuseIdentifier: "AddressTableCell")
        self.searchTableView.register(UINib(nibName: "AddressTableCell", bundle: nil), forCellReuseIdentifier: "AddressTableCell")

        
        self.destinationTextField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.searchTableView
        {
            return self.searchArray.count
        }
        
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableCell", for: indexPath) as! AddressTableCell

        if tableView == self.searchTableView
        {
            let prediction = self.searchArray[indexPath.row]
            cell.addressImageView.image = UIImage(named: "Group 1283")
            cell.addressTitleLabel!.text = prediction.attributedPrimaryText.string
            cell.addressDescriptionLabel!.text = prediction.attributedSecondaryText?.string
        }
        else
        {
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
        
        return cell
    }
    
    // MARK:- UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.flag == "destination"
        {
            if tableView == self.searchTableView
            {
                let prediction = self.searchArray[indexPath.row]
                let placeClient = GMSPlacesClient()
                placeClient.lookUpPlaceID(prediction.placeID) { (place, error) -> Void in
                    if error != nil
                    {
                         //show error
                        return
                    }
                    if let place = place
                    {
                        AppDelegate.sharedInstance.destination_location = PlaceLocation(name: prediction.attributedPrimaryText.string, longitude: place.coordinate.longitude, latitude: place.coordinate.latitude)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let editView = storyboard.instantiateViewController(withIdentifier: "DestinationViewController") as! DestinationViewController
                        editView.flag = "pickup"
                        self.navigationController?.pushViewController(editView, animated: true)
                    }
                    else
                    {
                        //show error
                    }
                }
            }
            else
            {
                let dic = self.array[indexPath.row] as [String: Any]
                
                let address_name = dic["address"] as! String
                let longitude = dic["address_lng"] as! String
                let latitude = dic["address_lat"] as! String
                AppDelegate.sharedInstance.destination_location = PlaceLocation(name: address_name, longitude: Double(longitude)!, latitude: Double(latitude)!)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let editView = storyboard.instantiateViewController(withIdentifier: "DestinationViewController") as! DestinationViewController
                editView.flag = "pickup"
                self.navigationController?.pushViewController(editView, animated: true)
            }
        }
        else
        {
            if tableView == self.searchTableView
            {
                let prediction = self.searchArray[indexPath.row]
                let placeClient = GMSPlacesClient()
                placeClient.lookUpPlaceID(prediction.placeID) { (place, error) -> Void in
                    if error != nil
                    {
                         //show error
                        return
                    }
                    if let place = place
                    {
                        AppDelegate.sharedInstance.pickup_location = PlaceLocation(name: prediction.attributedPrimaryText.string, longitude: place.coordinate.longitude, latitude: place.coordinate.latitude)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let pickView = storyboard.instantiateViewController(withIdentifier: "PickRideViewController") as! PickRideViewController
                        self.navigationController?.pushViewController(pickView, animated: true)
                    }
                    else
                    {
                        //show error
                    }
                }
            }
            else
            {
                let dic = self.array[indexPath.row] as [String: Any]

                let address_name = dic["address"] as! String
                let longitude = dic["address_lng"] as! String
                let latitude = dic["address_lat"] as! String
                AppDelegate.sharedInstance.pickup_location = PlaceLocation(name: address_name, longitude: Double(longitude)!, latitude: Double(latitude)!)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pickView = storyboard.instantiateViewController(withIdentifier: "PickRideViewController") as! PickRideViewController
                self.navigationController?.pushViewController(pickView, animated: true)
            }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        //self.tableView.isHidden = true
        //self.searchTableView.isHidden = false
        //tableDataSource.delegate = self
        //self.searchTableView.delegate = tableDataSource
        //self.searchTableView.dataSource = tableDataSource
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if textField.text!.isEmpty
        {
            self.tableView.isHidden = false
            self.searchTableView.isHidden = true
        }
        else
        {
            self.tableView.isHidden = true
            self.searchTableView.isHidden = false
            let filter = GMSAutocompleteFilter()
            filter.type = .noFilter
            filter.country = COUNTRY_CODE
            placesClient.findAutocompletePredictions(fromQuery: textField.text!, filter: filter, sessionToken: nil, callback: {(results, error) -> Void in
                if let error = error {
                    print("Autocomplete error \(error)")
                    return
                }
                self.searchArray = results!
                self.searchTableView.reloadData()
            })
        }
    }
}
