//
//  AddSavedPlaceViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/13/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class AddSavedPlaceViewController: UIViewController, GMSMapViewDelegate
{
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var placeNameView: UIView!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeLocationView: UIView!
    @IBOutlet weak var placeLocationTextField: UITextField!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var gymButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var coordinate = CLLocationCoordinate2D()
    var addressType = "home"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
        Functions.addCornerShadow(view: self.placeNameView, cornerRadius: 5)
        Functions.addCornerShadow(view: self.placeLocationView, cornerRadius: 5)
        Functions.addCorner(view: self.homeButton, cornerRadius: 17)
        Functions.addCorner(view: self.workButton, cornerRadius: 17)
        Functions.addCorner(view: self.gymButton, cornerRadius: 17)
        Functions.addCorner(view: self.otherButton, cornerRadius: 17)
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.containerView.frame
        rectShape.position = self.containerView.center
        rectShape.path = UIBezierPath(roundedRect: self.containerView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 40, height: 40)).cgPath
         self.containerView.layer.backgroundColor = UIColor.white.cgColor
         self.containerView.layer.mask = rectShape
        
        self.addButton.layer.masksToBounds = true
        self.addButton.layer.cornerRadius = 22
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
    {
        self.coordinate = coordinate
        self.mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 33.88894, longitude: 35.49442)
        marker.title = "Beirut"
        marker.snippet = "Lebanon"
        marker.icon = UIImage(named: "Group 8")
        marker.map = mapView
        let marker2 = GMSMarker(position: self.coordinate)
        marker2.map = self.mapView
        let image = UIImage(named: "Path 951")
        let markerView = UIImageView(image: image)
        marker2.iconView = markerView
        let location = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            guard error == nil else {
                return
            }
            guard placemarks!.count > 0 else {
                return
            }
            let pm = placemarks![0]
            self.placeLocationTextField.text = pm.thoroughfare
        })
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddAction(_ sender: Any)
    {
        if self.placeNameTextField.text!.isEmpty || self.placeLocationTextField.text!.isEmpty
        {
            return
        }
        ApiController.sharedInstance.saveAddress(address: self.placeLocationTextField.text!, address_name: self.placeNameTextField.text!, address_lng: self.coordinate.longitude, address_lat: self.coordinate.latitude, address_type: self.addressType, completionHandler: { (data, error) -> Void in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    @IBAction func onHomeAction(_ sender: Any)
    {
        self.addressType = "home"
        self.homeButton.backgroundColor = darkGrayColor
        self.workButton.backgroundColor = lightGrayColor
        self.gymButton.backgroundColor = lightGrayColor
        self.otherButton.backgroundColor = lightGrayColor
    }
    
    @IBAction func onWorkAction(_ sender: Any)
    {
        self.addressType = "work"
        self.homeButton.backgroundColor = lightGrayColor
        self.workButton.backgroundColor = darkGrayColor
        self.gymButton.backgroundColor = lightGrayColor
        self.otherButton.backgroundColor = lightGrayColor
    }
    
    @IBAction func onGymAction(_ sender: Any)
    {
        self.addressType = "gym"
        self.homeButton.backgroundColor = lightGrayColor
        self.workButton.backgroundColor = lightGrayColor
        self.gymButton.backgroundColor = darkGrayColor
        self.otherButton.backgroundColor = lightGrayColor
    }
    
    @IBAction func onOtherAction(_ sender: Any)
    {
        self.addressType = "other"
        self.homeButton.backgroundColor = lightGrayColor
        self.workButton.backgroundColor = lightGrayColor
        self.gymButton.backgroundColor = lightGrayColor
        self.otherButton.backgroundColor = darkGrayColor
    }
}
