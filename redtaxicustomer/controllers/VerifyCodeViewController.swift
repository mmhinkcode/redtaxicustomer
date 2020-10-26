//
//  VerifyCodeViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 7/30/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit

class VerifyCodeViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sentToLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var code1TextField: UITextField!
    @IBOutlet weak var code2TextField: UITextField!
    @IBOutlet weak var code3TextField: UITextField!
    @IBOutlet weak var code4TextField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var phoneNumber = ""
    var count = 0
    var timer: Timer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.phoneLabel.text = self.phoneNumber
        self.verifyButton.layer.masksToBounds = true
        self.verifyButton.layer.cornerRadius = 22
        
        self.code1TextField.becomeFirstResponder()
        
        self.code1TextField.delegate = self
        self.code2TextField.delegate = self
        self.code3TextField.delegate = self
        self.code4TextField.delegate = self
        
        self.code1TextField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.code2TextField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.code3TextField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.code4TextField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK:- UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        if range.length > 0  && range.location == 0
        {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 1
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        textField.isUserInteractionEnabled = false
        if textField == self.code1TextField
        {
            if (textField.text?.count)! == 1
            {
                self.code2TextField.becomeFirstResponder()
            }
        }
        else if textField == self.code2TextField
        {
            if (textField.text?.count)! == 1
            {
                self.code3TextField.becomeFirstResponder()
            }
        }
        else if textField == self.code3TextField
        {
            if (textField.text?.count)! == 1
            {
                self.code4TextField.becomeFirstResponder()
            }
        }
    }
    
    @IBAction func verifyCodeAction(_ sender: Any)
    {
        if self.code1TextField.text!.isEmpty || self.code2TextField.text!.isEmpty || self.code3TextField.text!.isEmpty || self.code4TextField.text!.isEmpty
        {
            return
        }
        let otp = "\(self.code1TextField.text ?? "")\(self.code2TextField.text ?? "")\(self.code3TextField.text ?? "")\(self.code4TextField.text ?? "")"
        ApiController.sharedInstance.login(otp: otp, phoneNumber: self.phoneNumber as String, completionHandler: { (data, error) -> Void in
            if error == nil
            {
                if data?.value(forKey: "status") as! Bool
                {
                    let dic = data?.value(forKey: "data") as! [String: Any]
                    let user = dic["user"] as! [String: Any]
                    do
                    {
                        let user_data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: true)
                        UserDefaults.standard.set(user_data, forKey: "user")
                    }
                    catch
                    {
                        print(error)
                    }
                    let access_token = dic["access_token"] as! String
                    UserDefaults.standard.set(access_token, forKey: "access_token")
                    DispatchQueue.main.async {
                        AppDelegate.sharedInstance.startApp()
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        self.titleLabel.text = "Wrong Code"
                        self.sentToLabel.text = "One feed seems wrong"
                        self.phoneLabel.text = "Try Again"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                        {
                            self.reset()
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func resendAction(_ sender: Any)
    {
        count = 60
        self.resendButton.isUserInteractionEnabled = false
        self.timerLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.reset()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        ApiController.sharedInstance.getOTP(phoneNumber: phoneNumber as String, completionHandler: { (data, error) -> Void in
        })
    }
    
    @objc func update()
    {
        if(count > 0)
        {
            count = count - 1
            self.timerLabel.text = String(format: "00:%02d", count)
        }
        else
        {
            self.resendButton.isUserInteractionEnabled = true
            self.timerLabel.isHidden = true
            self.timer.invalidate()
        }
    }
    
    func reset()
    {
        self.titleLabel.text = "Verify Mobile Number"
        self.sentToLabel.text = "A verification code has been sent to"
        self.phoneLabel.text = self.phoneNumber
        self.code1TextField.text = ""
        self.code2TextField.text = ""
        self.code3TextField.text = ""
        self.code4TextField.text = ""
        self.code1TextField.isUserInteractionEnabled = true
        self.code2TextField.isUserInteractionEnabled = true
        self.code3TextField.isUserInteractionEnabled = true
        self.code4TextField.isUserInteractionEnabled = true
        self.code1TextField.becomeFirstResponder()
    }
}
