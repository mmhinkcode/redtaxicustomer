//
//  PickRideViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/17/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import FSPagerView

class PickRideViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate, GMSMapViewDelegate
{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collapseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var pickupView: UIView!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var pickupTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pagerView: FSPagerView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.pagerView.reloadData()
        self.getDirections()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: AppDelegate.sharedInstance.pickup_location.latitude, longitude: AppDelegate.sharedInstance.pickup_location.longitude, zoom: Float(STANDARD_ZOOM))
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
        
        Functions.addCornerShadow(view: self.backButton, cornerRadius: 20)
        Functions.addCornerShadow(view: self.collapseButton, cornerRadius: 20)
        Functions.addCornerShadow(view: self.destinationView, cornerRadius: 5)
        Functions.addCornerShadow(view: self.pickupView, cornerRadius: 5)

        self.pickupTextField.text = AppDelegate.sharedInstance.pickup_location.name
        self.destinationTextField.text = AppDelegate.sharedInstance.destination_location.name

        self.nextButton.layer.masksToBounds = true
        self.nextButton.layer.cornerRadius = 22
                
        self.pagerView.register(UINib(nibName: "VehiculeTypeCell", bundle: nil), forCellWithReuseIdentifier: "VehiculeTypeCell")
        self.pagerView.itemSize = CGSize(width: 260, height: 200)
        self.pagerView.interitemSpacing = 35
        self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onExpandAction(_ sender: Any)
    {
        self.containerView.isHidden = !self.containerView.isHidden
        self.collapseButton.transform = self.collapseButton.transform.rotated(by: CGFloat.pi)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    {
        let infoWindow = CustomInfoWindow(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 25))
        infoWindow.titleLabel.text = marker.title
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.4)
        Functions.addCornerShadow(view: infoWindow, cornerRadius: 5)
        let fontAttributes = [NSAttributedString.Key.font: infoWindow.titleLabel.font]
        let size = (infoWindow.titleLabel.text! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        infoWindow.frame = CGRect(x: 0, y: 0, width: size.width + 2 * 7 + 7, height: 25)
        
        return infoWindow
    }
    
    // MARK:- FSPagerView DataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int
    {
        return AppDelegate.sharedInstance.carTypes.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell
    {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "VehiculeTypeCell", at: index) as! VehiculeTypeCell
        
        let dic = AppDelegate.sharedInstance.carTypes[index] as [String: Any]
        
        cell.vehiculeImageView.image = UIImage(named:"")
        cell.vehiculeTypeLabel.text = dic["type_name"] as? String
        cell.backgroundColor = .white
        Functions.addCornerShadow(view: cell, cornerRadius: 20)
        cell.contentView.layer.shadowRadius = 0
        
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int)
    {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int)
    {
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmRide")
        {
            let vc = segue.destination as! ConfirmRideViewController
            vc.car_type = AppDelegate.sharedInstance.carTypes[self.pagerView.currentIndex] as [String: Any]
        }
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
    
    func getDirections()
    {
        let from = CLLocationCoordinate2D(latitude: AppDelegate.sharedInstance.pickup_location.latitude, longitude: AppDelegate.sharedInstance.pickup_location.longitude)
        let to = CLLocationCoordinate2D(latitude: AppDelegate.sharedInstance.destination_location.latitude, longitude: AppDelegate.sharedInstance.destination_location.longitude)
        ApiController.sharedInstance.getDirections(from: from, to: to, completionHandler: { (data, error) -> Void in
            if error == nil
            {
                if (data!["error_message"] as? String) == nil
                {
                    if let routes = data!["routes"] as? [Any], routes.count > 0
                    {
                        DispatchQueue.main.async  {
                            OperationQueue.main.addOperation({
                                for route in routes
                                {
                                    let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                                    let points = routeOverviewPolyline.object(forKey: "points")
                                    let path = GMSPath.init(fromEncodedPath: points! as! String)
                                    let polyline = GMSPolyline.init(path: path)
                                    polyline.strokeWidth = 3
                                    polyline.strokeColor = redColor
                                    polyline.map = self.mapView
                                }
                            })
                            
                            let route = routes[0] as! NSDictionary
                            let arrLeg = route.value(forKey: "legs") as! NSArray
                            let dictleg = arrLeg.object(at: 0) as! NSDictionary
                            let duration = dictleg.value(forKey: "duration") as! NSDictionary
                            

                            let marker1 = GMSMarker()
                            marker1.position = CLLocationCoordinate2D(latitude: AppDelegate.sharedInstance.pickup_location.latitude, longitude: AppDelegate.sharedInstance.pickup_location.longitude)
                            marker1.title = AppDelegate.sharedInstance.pickup_location.name
                            let infoWindow = DestinationIconView(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 29))
                            infoWindow.titleLabel.text = AppDelegate.sharedInstance.pickup_location.name
                            infoWindow.durationLabel.text = (duration.value(forKey: "text") as? String)?.uppercased()
                            marker1.infoWindowAnchor = CGPoint(x: 0.5, y: 0.4)
                            Functions.addCornerShadow(view: infoWindow, cornerRadius: 5)
                            let fontAttributes = [NSAttributedString.Key.font: infoWindow.titleLabel.font]
                            let size = (infoWindow.titleLabel.text! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
                            let x = infoWindow.containerView.frame.origin.x + infoWindow.titleLabel.frame.origin.x
                            infoWindow.frame = CGRect(x: 0, y: 0, width: x + size.width + 2 * 7, height: 29)
                            marker1.iconView = infoWindow
                            marker1.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            marker1.map = self.mapView
                            
                            let marker2 = GMSMarker()
                            marker2.position = CLLocationCoordinate2D(latitude: AppDelegate.sharedInstance.destination_location.latitude, longitude: AppDelegate.sharedInstance.destination_location.longitude)
                            marker2.title = AppDelegate.sharedInstance.destination_location.name
                            marker2.icon = UIImage(named: "Group 877")
                            marker2.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            marker2.map = self.mapView

                            let bounds = GMSCoordinateBounds(coordinate: marker1.position, coordinate: marker2.position)
                            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: self.containerView.frame.origin.y + self.containerView.frame.size.height + 25, left: 10.0, bottom: self.view.frame.size.height - self.pagerView.frame.origin.y + 25, right: 10.0))
                            self.mapView.animate(with: update)
                        }
                    }
                }
            }
        })
    }
}
