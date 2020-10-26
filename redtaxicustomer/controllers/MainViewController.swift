//
//  MainViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/6/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import GoogleMaps
import KYDrawerController

class MainViewController: UIViewController
{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var nowButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var saved1Button: UIButton!
    @IBOutlet weak var saved2Button: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var redeemView: UIView!
    @IBOutlet weak var redeemButton: UIButton!
    
    var array = [Dictionary<String, Any>]()
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getAllAddresses()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let camera = GMSCameraPosition.camera(withLatitude: 33.88894, longitude: 35.49442, zoom: Float(MAX_ZOOM))
        self.mapView.camera = camera
        do
        {
            if let styleURL = Bundle.main.url(forResource: "map_style", withExtension: "json")
            {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 33.88894, longitude: 35.49442)
        marker.title = "Beirut"
        marker.snippet = "Lebanon"
        marker.icon = UIImage(named: "Group 8")
        marker.map = mapView
                
        Functions.addCornerShadow(view: self.menuButton, cornerRadius: 20)
        Functions.addCornerShadow(view: self.notificationButton, cornerRadius: 20)
        Functions.addCornerShadow(view: self.nowButton, cornerRadius: 5)
        Functions.addCornerShadow(view: self.scheduleButton, cornerRadius: 5)
        Functions.addCornerShadow(view: self.destinationView, cornerRadius: 5)
        Functions.addCornerShadow(view: self.stopButton, cornerRadius: 5)
        Functions.addCornerShadow(view: self.saved1Button, cornerRadius: 5)
        Functions.addCornerShadow(view: self.saved2Button, cornerRadius: 5)
        Functions.addCornerShadow(view: self.starButton, cornerRadius: 5)
        Functions.addCornerShadow(view: self.redeemView, cornerRadius: 10)
        Functions.addCornerShadow(view: self.redeemButton, cornerRadius: 15)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "destination"
        {
            let vc = segue.destination as? DestinationViewController
            vc?.flag = "destination"
        }
    }
    
    @IBAction func onMenuAction(_ sender: Any)
    {
        let drawerController = self.navigationController?.parent as? KYDrawerController
        drawerController!.setDrawerState(.opened, animated: true)
    }
    
    func getAllAddresses()
    {
        ApiController.sharedInstance.getAllAddresses(completionHandler: { (data, error) -> Void in
            if error == nil
            {
                self.array = data?.value(forKey: "data") as! [Dictionary<String, Any>]
                DispatchQueue.main.async {
                    if self.array.count > 1
                    {
                        self.saved1Button.isHidden = false
                        self.saved2Button.isHidden = false
                        let dic1 = self.array[0] as [String: Any]
                        self.saved1Button.setTitle((dic1["address_type"] as? String)?.capitalized, for: .normal)
                        let dic2 = self.array[1] as [String: Any]
                        self.saved2Button.setTitle((dic2["address_type"] as? String)?.capitalized, for: .normal)
                    }
                    else if self.array.count > 0
                    {
                        self.saved1Button.isHidden = false
                        self.saved2Button.isHidden = true
                        let dic = self.array[0] as [String: Any]
                        self.saved1Button.setTitle((dic["address_type"] as? String)?.capitalized, for: .normal)
                    }
                    else
                    {
                        self.saved1Button.isHidden = true
                        self.saved2Button.isHidden = true
                    }
                }
            }
        })
    }
    
    func getOnlineSessions()
    {
        ApiController.sharedInstance.getOnlineSessions(completionHandler: { (data, error) -> Void in
            if error == nil
            {
                let cars = data?.value(forKey: "data") as! [Dictionary<String, Any>]
                DispatchQueue.main.async {
                    self.mapView.clear()
                    for car in cars
                    {
                        let marker = GMSMarker()
                        let latitude = car["latitudes"] as! Double
                        let longitude = car["longitudes"] as! Double
                        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        marker.title = car["status"] as? String
                        marker.icon = UIImage(named: "red-taxi-in-lebanon")
                        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        marker.map = self.mapView
                    }
                }
            }
        })
    }
    
    @IBAction func onSave1Action(_ sender: Any)
    {
        let dic = self.array[0] as [String: Any]
        
        let address_name = dic["address"] as! String
        let longitude = dic["address_lng"] as! String
        let latitude = dic["address_lat"] as! String
        AppDelegate.sharedInstance.destination_location = PlaceLocation(name: address_name, longitude: Double(longitude)!, latitude: Double(latitude)!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editView = storyboard.instantiateViewController(withIdentifier: "DestinationViewController") as! DestinationViewController
        editView.flag = "pickup"
        self.navigationController?.pushViewController(editView, animated: true)
    }
    
    @IBAction func onSave2Action(_ sender: Any)
    {
        let dic = self.array[1] as [String: Any]
        
        let address_name = dic["address"] as! String
        let longitude = dic["address_lng"] as! String
        let latitude = dic["address_lat"] as! String
        AppDelegate.sharedInstance.destination_location = PlaceLocation(name: address_name, longitude: Double(longitude)!, latitude: Double(latitude)!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editView = storyboard.instantiateViewController(withIdentifier: "DestinationViewController") as! DestinationViewController
        editView.flag = "pickup"
        self.navigationController?.pushViewController(editView, animated: true)
    }
    
    @IBAction func onNowAction(_ sender: Any)
    {
        AppDelegate.sharedInstance.ride_date = ""
        self.nowButton.backgroundColor = darkGrayColor
        self.nowButton.setTitleColor(.white, for: .normal)
        self.scheduleButton.backgroundColor = .white
        self.scheduleButton.setTitleColor(darkGrayColor, for: .normal)
    }
    
    @IBAction func onScheduleAction(_ sender: Any)
    {
        self.nowButton.backgroundColor = .white
        self.nowButton.setTitleColor(darkGrayColor, for: .normal)
        self.scheduleButton.backgroundColor = darkGrayColor
        self.scheduleButton.setTitleColor(.white, for: .normal)
    }
}
