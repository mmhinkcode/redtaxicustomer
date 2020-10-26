//
//  ApiController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 7/29/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import MapKit

class ApiController
{
   static let sharedInstance = ApiController()
    
    func percentEncoded(parameters: [String: Any]) -> Data?
    {
        return parameters.map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
    
    func getOTP(phoneNumber: String, completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(GET_OTP_API)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["phone": phoneNumber]
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func login(otp: String, phoneNumber: String, completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(LOGIN_OTP_API)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["otp": otp, "phone": phoneNumber]
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getCountries(completionHandler: @escaping (_ data: NSArray?, _ error: Error?) -> Void)
    {
        let url = URL(string: COUNTRIES_API)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
                completionHandler(json, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getFare(pickup_address: String, pickup_airport: Bool, pickup_address_lng: Float, pickup_address_lat: Float, destinations: [String], ride_distance: Double, ride_duration: String, ride_date: String, currency: String, payment_method: String, services: [String], car_type_id: Int, coupon_value: String, completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(REQUEST_API)")!
        var request = URLRequest(url: url)
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = ["pickup_address": pickup_address, "pickup_airport": "false", "pickup_address_lng": pickup_address_lng, "pickup_address_lat": pickup_address_lat, "ride_distance": ride_distance, "ride_duration": ride_duration, "ride_date": ride_date, "currency": currency, "payment_method": payment_method, "car_type_id": car_type_id, "coupon_value": coupon_value] as NSMutableDictionary
        if destinations.count > 0
        {
            for i in 0...destinations.count-1
            {
                let destination = destinations[i] as String
                parameters.setValue(destination, forKey: "destinations[\(i)]")
            }
        }
        if services.count > 0
        {
            for i in 0...services.count-1
            {
                let service = services[i] as String
                parameters.setValue(service, forKey: "services[\(i)]")
            }
        }
        request.httpBody = self.percentEncoded(parameters: parameters as! [String : Any])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func setProfile(first_name: String, last_name: String, email: String, image: UIImage, completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(PROFILE_API)")!
        var request = URLRequest(url: url)
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let imageData:NSData = image.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        let parameters = ["first_name": first_name, "last_name": last_name, "email": email, "image": strBase64] as NSMutableDictionary
        request.httpBody = self.percentEncoded(parameters: parameters as! [String : Any])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                print(String(data:data, encoding:.utf8)!)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getAllServices(completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(SERVICE_API)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func saveAddress(address: String, address_name: String, address_lng: Double, address_lat: Double, address_type: String, completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(ADDRESS_API)")!
        var request = URLRequest(url: url)
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["address": address, "address_name": address_name, "address_lng": "\(address_lng)", "address_lat": "\(address_lat)", "address_type": address_type]
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func deleteAddress(address_id: Int, completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(ADDRESS_API)/\(address_id)")!
        var request = URLRequest(url: url)
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getAllAddresses(completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(ADDRESS_API)")!
        var request = URLRequest(url: url)
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getAllCarTypes(completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(CAR_TYPES_API)")!
        var request = URLRequest(url: url)
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getOnlineSessions(completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(ONLINE_SESSIONS_API)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    func getDirections(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(from.latitude),\(from.longitude)&destination=\(to.latitude),\(to.longitude)&mode=driving&channel=\(CHANNEL)&client=\(CLIENT)"
        let signedURLString = Functions.getSignaturedUrl(completeURL: urlString)
        let url = URL(string: signedURLString)
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error) in
            if error != nil
            {
                completionHandler(nil, error)
            }
            else
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    completionHandler(json as NSDictionary, error)
                }
                catch let error as NSError
                {
                    completionHandler(nil, error)
                }
            }
        })
        task.resume()
    }
    
    func getFares(completionHandler: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void)
    {
        let url = URL(string: "\(ENDPOINT)\(FARES_API)")!
        var request = URLRequest(url: url)
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["currency": "LBP"]
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                completionHandler(json! as NSDictionary, error)
            }
            catch
            {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}
