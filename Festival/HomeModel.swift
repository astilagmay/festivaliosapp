//
//  HomeModel.swift
//  Festival
//
//  Created by Hale Pascua on 18/12/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import Foundation

protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

@objcMembers
class HomeModel: NSObject, URLSessionDataDelegate{
    // attributes
    weak var delegate: HomeModelProtocol!
    
    // set urlPath to URL Path of PHP File to be executed
    let urlPath_events="http://mealier-films.000webhostapp.com/queryevents.php"
    let urlPath_locations="http://mealier-films.000webhostapp.com/querylocations.php"
    
    func downloadItems_Events(){
        let url: URL = URL(string: urlPath_events)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil{
                print("Failed to download data")
            }
            else{
                print("Data downloaded")
                self.parseJSON_Events(data!)
            }
        }
        
        task.resume()
    }
    
    func downloadItems_Locations(){
        let url: URL = URL(string: urlPath_locations)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil{
                print("Failed to download data")
            }
            else{
                print("Data downloaded")
                self.parseJSON_Locations(data!)
            }
        }
        
        task.resume()
    }
    
    func parseJSON_Events(_ data:Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }
        catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let events = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            
            let event = EventModel()
            
            // ensure none of the JSONElement values are nil
            if let name = jsonElement["name"] as? String,
               let date = jsonElement["date"] as? String,
               let venue = jsonElement["venue"] as? String,
               let start_time = jsonElement["start_time"] as? String,
               let endtime = jsonElement["endtime"] as? String,
               let entry_price = jsonElement["entry_price"] as? String,
               let descr = jsonElement["descr"] as? String,
               let phone_num = jsonElement["phone_num"] as? String
            {
                event.name = name
                event.date = date
                event.venue = venue
                event.start_time = start_time
                event.endtime = endtime
                event.entry_price = entry_price
                event.descr = descr
                event.phone_num = phone_num
            }
            
            events.add(event)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: events)
        })
    }
    
    func parseJSON_Locations(_ data:Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }
        catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            
            let location = LocationModel()
            
            // ensure none of the JSONElement values are nil
            if let name = jsonElement["name"] as? String,
                let full_address = jsonElement["full_address"] as? String,
                let latitude = jsonElement["latitude"] as? String,
                let longitude = jsonElement["longitude"] as? String
            {
                location.name = name
                location.full_address = full_address
                location.latitude = latitude
                location.longitude = longitude
            }
            
            locations.add(location)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: locations)
        })
    }
}
