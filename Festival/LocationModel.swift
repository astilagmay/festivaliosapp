//
//  LocationModel.swift
//  Festival
//
//  Created by Hale Pascua on 18/12/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import Foundation

@objcMembers
class LocationModel: NSObject{
    // attributes
    var name         : String?
    var full_address : String?
    var latitude     : String?
    var longitude    : String?
    
    // empty constructor
    override init(){}
    
    // construct with parameters
    init(name: String, full_address: String, latitude: String, longitude: String){
        self.name = name
        self.full_address = full_address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // print attributes (for debugging)
    override var description: String{
        return "Name: \(name) \nFull address: \(full_address) \nLatitude: \(latitude) \nLongitude: \(longitude)"
    }
}
