//
//  TripDetailsViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 9/17/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import GoogleMaps

class TripDetailsViewController: UIViewController
{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backButton: UIButton!
    
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
                
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
