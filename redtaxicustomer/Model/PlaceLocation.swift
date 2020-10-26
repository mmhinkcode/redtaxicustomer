//
//  PlaceLocation.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 8/17/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import Foundation

class PlaceLocation: NSObject
{
    var name: String = ""
    var longitude: Double = 0.0
    var latitude:Double = 0.0
    
    override init()
    {
        
    }
    
    init(name: String, longitude: Double, latitude:Double)
    {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
}
