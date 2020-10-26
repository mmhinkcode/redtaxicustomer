//
//  ConfirmRideViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/25/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class ConfirmRideViewController: UIViewController, GMSMapViewDelegate, UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var fareAfterDiscountLabel: UILabel!
    
    var car_type = [String: Any]()
    var ride_distance = 0
    var ride_duration = ""
    private var detailsTransitioningDelegate: InteractiveModalTransitioningDelegate!

    override func viewWillAppear(_ animated: Bool)
    {
        self.getDirections()
    }
    
    override func viewDidLayoutSubviews()
    {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.containerView.frame
        rectShape.position = self.containerView.center
        rectShape.path = UIBezierPath(roundedRect: self.containerView.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 40, height: 40)).cgPath
         self.containerView.layer.backgroundColor = UIColor.white.cgColor
         self.containerView.layer.mask = rectShape
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

        self.confirmButton.layer.masksToBounds = true
        self.confirmButton.layer.cornerRadius = 22
        
        self.carTypeLabel.text = self.car_type["type_name"] as? String
    }
    
    @IBAction func onBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func onTapPayUsingAction(_ sender: Any)
    {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "popoverSegue"
        {
            let controller = segue.destination as! PromoCodeViewController
            detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: controller)
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = detailsTransitioningDelegate
        }
    }
    
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .formSheet
    }
     
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
     
    }
     
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
    return true
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
                        let route = routes[0] as! NSDictionary
                        let arrLeg = route.value(forKey: "legs") as! NSArray
                        let dictleg = arrLeg.object(at: 0) as! NSDictionary
                        let distance = dictleg.value(forKey: "distance") as! NSDictionary
                        //self.ride_distance = ((distance.value(forKey: "text") as? String)?.uppercased())!
                        self.ride_distance = distance.value(forKey: "value") as! Int
                        let duration = dictleg.value(forKey: "duration") as! NSDictionary
                        self.ride_duration = ((duration.value(forKey: "text") as? String)?.uppercased())!
                        self.getFare()
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
                
                            let temp = Double(self.ride_distance)/1000
                            self.distanceLabel.text = String(format: "%.1f KM", temp)
                            
                            let marker1 = GMSMarker()
                            marker1.position = CLLocationCoordinate2D(latitude: AppDelegate.sharedInstance.pickup_location.latitude, longitude: AppDelegate.sharedInstance.pickup_location.longitude)
                            marker1.title = AppDelegate.sharedInstance.pickup_location.name
                            let infoWindow = DestinationIconView(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 29))
                            infoWindow.titleLabel.text = AppDelegate.sharedInstance.pickup_location.name
                            infoWindow.durationLabel.text = self.ride_duration
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
                            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: self.backButton.frame.origin.y + self.backButton.frame.size.height + 25, left: 10.0, bottom: self.view.frame.size.height - self.containerView.frame.origin.y + 25, right: 10.0))
                            self.mapView.animate(with: update)
                        }
                    }
                }
            }
        })
    }
    
    func getFare()
    {
        var pickup_airport = false
        if AppDelegate.sharedInstance.pickup_location.name.contains("airport")
        {
            pickup_airport = true
        }
        var destination_airport = false
        if AppDelegate.sharedInstance.destination_location.name.contains("airport")
        {
            destination_airport = true
        }
        let ride_date = AppDelegate.sharedInstance.ride_date
        ApiController.sharedInstance.getFare(pickup_address: AppDelegate.sharedInstance.pickup_location.name, pickup_airport: pickup_airport, pickup_address_lng: Float(AppDelegate.sharedInstance.pickup_location.longitude), pickup_address_lat: Float(AppDelegate.sharedInstance.pickup_location.latitude), destinations: ["\(AppDelegate.sharedInstance.pickup_location.name)|\(AppDelegate.sharedInstance.destination_location.name)|\(self.ride_duration)|lat:\(Float(AppDelegate.sharedInstance.destination_location.latitude))|lng:\(Float(AppDelegate.sharedInstance.destination_location.longitude))|\(destination_airport)"], ride_distance: Double(self.ride_distance)/1000, ride_duration: self.ride_duration, ride_date: ride_date, currency: "LBP", payment_method: "Cash", services: [], car_type_id: self.car_type["id"] as! Int, coupon_value: "0", completionHandler: { (data, error) -> Void in
            if error == nil
            {
                let result = data?.value(forKey: "data") as! [String: Any]
                let fare = result["fare"] as! Int
                let currency = result["currency"] as! String
                DispatchQueue.main.async {
                    if result["fare_after_discount"] is NSNull
                    {
                        self.fareLabel.isHidden = true
                        self.fareAfterDiscountLabel.text = "\(fare) \(currency)"
                    }
                    else
                    {
                        let fare_after_discount = result["fare_after_discount"] as! Int
                        self.fareLabel.text = "\(fare) \(currency)"
                        self.fareAfterDiscountLabel.text = "\(fare_after_discount) \(currency)"
                    }
                }
            }
        })
    }
}
