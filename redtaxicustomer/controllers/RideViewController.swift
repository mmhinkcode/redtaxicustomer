//
//  RideViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/31/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class RideViewController: UIViewController, GMSMapViewDelegate
{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var arrivingInView: UIView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var arrivedView: UIView!
    @IBOutlet weak var willArriveView: UIView!

    var ride_duration = ""

    override func viewWillAppear(_ animated: Bool)
    {
        self.getDirections()
    }
    
    override func viewDidLayoutSubviews()
    {
        Functions.addTopCorner(view: self.arrivingInView, cornerRadius: 40)
        Functions.addTopCorner(view: self.arrivedView, cornerRadius: 40)
        Functions.addTopCorner(view: self.willArriveView, cornerRadius: 40)
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
        

        self.cancelButton.layer.masksToBounds = true
        self.cancelButton.layer.cornerRadius = 22
        
        self.messageButton.layer.masksToBounds = true
        self.messageButton.layer.cornerRadius = 22
        self.callButton.layer.masksToBounds = true
        self.callButton.layer.cornerRadius = 20
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 33
        
        self.showCancelView()

        NotificationCenter.default.addObserver(self, selector: #selector(self.showArrivingInView), name: Notification.Name("NotificationIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showArrivedView), name: Notification.Name("NotificationIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showWillArriveView), name: Notification.Name("NotificationIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showTip), name: Notification.Name("NotificationIdentifier"), object: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.showArrivingInView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.showArrivedView()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.showWillArriveView()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.showTip()
                    })
                })
            })
        })
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
    
    @IBAction func onCancelAction(_ sender: Any)
    {
        AppDelegate.sharedInstance.startApp()
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
                        let duration = dictleg.value(forKey: "duration") as! NSDictionary
                        self.ride_duration = ((duration.value(forKey: "text") as? String)?.uppercased())!
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
                            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100, left: 10.0, bottom: self.view.frame.size.height - self.cancelView.frame.origin.y + 25, right: 10.0))
                            self.mapView.animate(with: update)
                        }
                    }
                }
            }
        })
    }
    
    @objc func showCancelView()
    {
        self.cancelView.isHidden = false
        self.arrivingInView.isHidden = true
        self.arrivedView.isHidden = true
        self.willArriveView.isHidden = true
    }
    
    @objc func showArrivingInView()
    {
        self.cancelView.isHidden = true
        self.arrivingInView.isHidden = false
        self.arrivedView.isHidden = true
        self.willArriveView.isHidden = true
    }
    
    @objc func showArrivedView()
    {
        self.cancelView.isHidden = true
        self.arrivingInView.isHidden = true
        self.arrivedView.isHidden = false
        self.willArriveView.isHidden = true
    }
    
    @objc func showWillArriveView()
    {
        self.cancelView.isHidden = true
        self.arrivingInView.isHidden = true
        self.arrivedView.isHidden = true
        self.willArriveView.isHidden = false
    }
    
    @objc func showTip()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TipViewController") as! TipViewController
        let root = UINavigationController(rootViewController: vc)
        AppDelegate.sharedInstance.window?.rootViewController = root
    }
}
