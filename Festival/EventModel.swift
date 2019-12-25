//
//  EventModel.swift
//  Festival
//
//  Created by Hale Pascua on 18/12/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import Foundation

@objcMembers
class EventModel: NSObject{
    // attributes
    var name        : String?
    var date        : String?
    var venue       : String?
    var start_time  : String?
    var endtime     : String?
    var entry_price : String?
    var descr       : String?
    var phone_num   : String?
    
    // empty constructor
    override init(){}
    
    // construct with parameters
    init(name: String, date: String, venue: String, start_time: String, endtime: String, entry_price: String, descr: String, phone_num: String){
        self.name = name
        self.date = date
        self.venue = venue
        self.start_time = start_time
        self.endtime = endtime
        self.entry_price = entry_price
        self.descr = descr
        self.phone_num = phone_num
    }
}
