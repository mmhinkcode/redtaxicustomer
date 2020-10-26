//
//  Functions.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/3/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
import QuartzCore

class Functions
{
    class func addCorner(view: UIView, cornerRadius: CGFloat)
    {
        view.layer.cornerRadius = cornerRadius
        self.addShadow(view: view)
    }
    
    class func addShadow(view: UIView)
    {
        view.layer.shadowColor = darkGrayColor.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    class func addBorder(view: UIView, cornerRadius: CGFloat, borderColor: UIColor)
    {
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = cornerRadius
    }
    
    class func addTopCorner(view: UIView, cornerRadius: CGFloat)
    {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
         view.layer.mask = rectShape
        self.addShadow(view: view)
    }
    
    class func addLeftCorner(view: UIView, cornerRadius: CGFloat)
    {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft , .bottomLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
         view.layer.mask = rectShape
        self.addShadow(view: view)
    }
    
    class func addRightCorner(view: UIView, cornerRadius: CGFloat)
    {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topRight , .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
         view.layer.mask = rectShape
        self.addShadow(view: view)
    }
        
    class func addCornerShadow(view: UIView, cornerRadius: CGFloat)
    {
        self.addCorner(view: view, cornerRadius: cornerRadius)
        self.addShadow(view: view)
    }
    
    class func addInputAccessoryView(textField: UITextField, frame: CGRect)
    {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 45))
        customView.backgroundColor = .white
        let button = UIButton(frame: CGRect(x: (customView.frame.size.width - 121)/2, y: (customView.frame.size.height - 20)/2, width: 121, height: 20))
        button.setTitle("Choose on map", for: .normal)
        button.setTitleColor(darkGrayColor, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 13)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.setImage(UIImage(named: "Path 952"), for: .normal)
        customView.addSubview(button)
        self.addShadow(view: customView)
        textField.inputAccessoryView = customView
    }
    
    class func getSignaturedUrl(completeURL: String) -> String
    {
        let ClientId = "gme-redtaximobapp"
        let browserKey = "AIzaSyAig4kAbOpsYW1GuVLRGw3ki1Xj__C7hGc"
        let urlCompose = completeURL.components(separatedBy: "&client=\(ClientId)")
        let newUrl = urlCompose[0] + "&key=\(browserKey)"
        
        return newUrl
    }
    
    class func pinMarkerImageViewWith(etaString: String) -> UIImageView
    {
        let pinMarkerImage = UIImage(named: "Group 8")
        
        let widthOfPinMarkerView = pinMarkerImage!.size.width
        let heightOfPinMarkerView = pinMarkerImage!.size.height

        let tempPinMarkerView = UIImageView()
        tempPinMarkerView.frame = CGRect(x: 0, y: 0, width: widthOfPinMarkerView, height: heightOfPinMarkerView)
        tempPinMarkerView.backgroundColor = .clear
        tempPinMarkerView.image = pinMarkerImage
        
        let etaLabelOnPinView = UILabel()
        etaLabelOnPinView.frame = CGRect(x: 0.0, y: -1.0, width: widthOfPinMarkerView, height: 29.0)
        etaLabelOnPinView.backgroundColor = .clear
        etaLabelOnPinView.textAlignment = .center
        tempPinMarkerView.addSubview(etaLabelOnPinView)
        
        etaLabelOnPinView.text = etaString
        
        return tempPinMarkerView
    }
}
