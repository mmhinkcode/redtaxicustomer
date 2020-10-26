//
//  AppDelegate.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 7/28/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import KYDrawerController
import PusherSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let sharedInstance = UIApplication.shared.delegate as! AppDelegate
    var destination_location = PlaceLocation()
    var pickup_location = PlaceLocation()
    var countries = [Dictionary<String, Any>]()
    var carTypes = [Dictionary<String, Any>]()
    var ride_date = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let options = PusherClientOptions(
          host: .cluster("PUSHER_CLUSTER")
        )

        let pusher = Pusher(key: "PUSHER_APP_KEY", options: options)
        pusher.connect()
        
        let myChannel = pusher.subscribe("my-channel")
        
        let _ = myChannel.bind(eventName: "my-event", callback: { (data: Any?) -> Void in
          if let data = data as? [String : AnyObject] {
            if let message = data["message"] as? String {
                print(message)
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: message)
            }
          }
        })
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(GOOGLE_MAP_KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_MAP_KEY)

        self.startApp()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func startApp()
    {
        self.getCountries()
        if UserDefaults.standard.value(forKey: "access_token") != nil
        {
            self.getAllCarTypes()
            if UserDefaults.standard.value(forKey: "user") != nil
            {
                let user_data = UserDefaults.standard.value(forKey: "user") as! Data
                do
                {
                    let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(user_data) as! [String: Any]
                    if (user["email"] as? String) != nil
                    {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let leftPanelController = storyBoard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
                        let centerViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
                        drawerController.mainViewController = UINavigationController(
                            rootViewController: centerViewController
                        )
                        drawerController.drawerViewController = UINavigationController(
                            rootViewController: leftPanelController
                        )
                        self.window?.rootViewController = drawerController
                    }
                    else
                    {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        let root = UINavigationController(rootViewController: vc)
                        self.window?.rootViewController = root
                    }
                }
                catch
                {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                    let root = UINavigationController(rootViewController: vc)
                    self.window?.rootViewController = root
                }
            }
            else
            {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                let root = UINavigationController(rootViewController: vc)
                self.window?.rootViewController = root
            }
        }
        else
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "GetStartedViewController") as! GetStartedViewController
            self.window?.rootViewController = vc
        }
    }
    
    func openMenu()
    {
        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let leftPanelController = storyBoard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        let centerViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        drawerController.mainViewController = UINavigationController(
            rootViewController: centerViewController
        )
        drawerController.drawerViewController = UINavigationController(
            rootViewController: leftPanelController
        )
        self.window?.rootViewController = drawerController
        drawerController.setDrawerState(.closed, animated: true)
    }
    
    func getCountries()
    {
        ApiController.sharedInstance.getCountries(completionHandler: { (data, error) -> Void in
            if error == nil
            {
                self.countries = data! as! [Dictionary<String, Any>]
            }
        })
    }
    
    func getAllCarTypes()
    {
        ApiController.sharedInstance.getAllCarTypes(completionHandler: { (data, error) -> Void in
            if error == nil
            {
                self.carTypes = data?.value(forKey: "data") as! [Dictionary<String, Any>]
            }
        })
    }
}

