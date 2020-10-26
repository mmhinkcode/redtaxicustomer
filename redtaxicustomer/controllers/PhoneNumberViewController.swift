//
//  PhoneNumberViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 7/29/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

extension UIViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

class PhoneNumberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate
{
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneCodeButton: UIButton!
    @IBOutlet weak var countriesView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countriesTable: UITableView!

    var filteredArray = [Dictionary<String, Any>]()
    var selectedCountry = Dictionary<String, Any>()
    var searchActive = false
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.selectedCountry = AppDelegate.sharedInstance.countries.filter() { $0["name"] as! String == "Lebanon" }.first!
        let callingCodes = self.selectedCountry["callingCodes"] as! NSArray
        let phoneCode = callingCodes.firstObject as! NSString
        self.phoneCodeButton.setTitle("+\(phoneCode as String)", for: .normal)
        self.countriesTable.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.phoneNumberView.layer.masksToBounds = true
        self.phoneNumberView.layer.cornerRadius = 22
        self.phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Phone Number",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.nextButton.layer.masksToBounds = true
        self.nextButton.layer.cornerRadius = 22
        
        self.countriesView.layer.masksToBounds = true
        self.countriesView.layer.cornerRadius = 40
        let headerView = UIView(frame: CGRect.zero)
        let footerView = UIView(frame: CGRect.zero)
        self.countriesTable.tableHeaderView = headerView
        self.countriesTable.tableFooterView = footerView
        
        if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
            //textfield.textColor = UIColor.blue
            textfield.backgroundColor = UIColor.white
            textfield.font = UIFont(name:"Poppins-Regular",size:13)
        }
        
        self.searchBar.backgroundImage = UIImage()

        //self.searchBar.setBackgroundImage(UIImage(named: "Rectangle 8"), for: UIBarPosition(rawValue: 0)!, barMetrics:.default)
        
        //self.searchBar.barTintColor = UIColor(patternImage: UIImage(named: "Rectangle 8")!)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func showCountriesTable(_ sender: Any)
    {
        self.countriesView.isHidden = false
    }
    
    // MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.searchActive)
        {
            return self.filteredArray.count
        }
        return AppDelegate.sharedInstance.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryTableCell?

        let dic : NSDictionary
        if(self.searchActive)
        {
            dic = self.filteredArray[indexPath.row] as NSDictionary
        }
        else
        {
            dic = AppDelegate.sharedInstance.countries[indexPath.row] as NSDictionary
        }
        let callingCodes = dic["callingCodes"] as! NSArray
        let phoneCode = callingCodes.firstObject as! NSString
        let selectedCallingCodes = self.selectedCountry["callingCodes"] as! NSArray
        let selectedPhoneCode = selectedCallingCodes.firstObject as! NSString

        cell?.titleLabel?.text = dic["name"] as? String
        if selectedPhoneCode == phoneCode
        {
            cell?.titleLabel.textColor = redColor
            cell?.accessoryView =  UIImageView(image: UIImage(named: "Group 1044"))
        }
        else
        {
            cell?.titleLabel.textColor = darkGrayColor
            cell?.accessoryView = nil
        }
        
        return cell!
    }
    
    // MARK:- UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let dic : NSDictionary
        if(self.searchActive)
        {
            dic = self.filteredArray[indexPath.row] as NSDictionary
        }
        else
        {
            dic = AppDelegate.sharedInstance.countries[indexPath.row] as NSDictionary
        }
        let callingCodes = dic["callingCodes"] as! NSArray
        let phoneCode = callingCodes.firstObject as! NSString
        self.selectedCountry = (dic as NSDictionary) as! [String : Any]
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.phoneCodeButton.setTitle("+\(phoneCode as String)", for: .normal)
            self.countriesView.isHidden = true
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        self.searchActive = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchActive = false;
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        self.countriesTable.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.countriesTable.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchActive = false
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchActive = true;
        self.searchBar.showsCancelButton = true
        let searchPredicate = NSPredicate(format: "name CONTAINS[C] %@", searchText)
        self.filteredArray = (AppDelegate.sharedInstance.countries as NSArray).filtered(using: searchPredicate) as! [Dictionary<String, Any>]
        self.countriesTable.reloadData()
    }
        
    @IBAction func nextAction(_ sender: Any)
    {
        if self.phoneNumberTextField.text!.isEmpty
        {
            return
        }
        let callingCodes = self.selectedCountry["callingCodes"] as! NSArray
        let phoneCode = callingCodes.firstObject as! NSString
        let phoneNumber = "+\(phoneCode)\(self.phoneNumberTextField.text ?? "")"
        ApiController.sharedInstance.getOTP(phoneNumber: phoneNumber as String, completionHandler: { (data, error) -> Void in
            if error == nil
            {
                if data?.value(forKey: "status") as! Bool
                {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "verifyOTP", sender: nil)
                    }
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "verifyOTP")
        {
            let callingCodes = self.selectedCountry["callingCodes"] as! NSArray
            let phoneCode = callingCodes.firstObject as! NSString
            let phoneNumber = "+\(phoneCode)\(self.phoneNumberTextField.text ?? "")"
            let vc = segue.destination as! VerifyCodeViewController
            vc.phoneNumber = phoneNumber
        }
    }
}
