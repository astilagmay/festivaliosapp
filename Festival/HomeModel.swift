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
    
    struct EventInfo: Decodable {
        let data: [EventStruct]
    }
    
    struct EventStruct: Decodable {
        let name: String?
        let date: String?
        let venue: String?
        let starttime: String?
        let endtime: String?
        let entryprice: String?
        let descr: String?
        let phonenum: String?
    }
    
    var EventNames = [String]()
    var EventDates = [String]()
    var EventLocs = [String]()
    var EventStart = [String]()
    var EventEnd = [String]()
    var EventPrices = [String]()
    var EventDesc = [String]()
    var EventPhone = [String]()
    
    func getInfo() {
            
            let semaphore = DispatchSemaphore (value: 0)

            var request = URLRequest(url: URL(string: "http://mealier-films.000webhostapp.com/queryevents.php")!,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                do {
                    let parsedData = try decoder.decode(EventInfo.self, from: data)
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    formatter.dateFormat = "HH"

                    
                    //loop through whole array
                    for array in parsedData.data {
                        
                        
                        
                        //get all events
                        self.EventNames.append(array.name ?? "N/A")
                        self.EventDates.append(array.date ?? "N/A")
                        self.EventLocs.append(array.venue ?? "N/A")
                        self.EventStart.append(array.starttime ?? "N/A" )
                        self.EventEnd.append(array.endtime ?? "N/A")
                        self.EventPrices.append(array.entryprice ?? "N/A")
                        self.EventDesc.append(array.descr ?? "N/A")
                        
                        //get start hour
                        var splitTime = array.starttime!.split(separator: ":")
                        var startHour = Int(splitTime[0])
                        
                        if array.starttime!.contains("PM") {
                            startHour = startHour! + 12
                        }
                        
                        //get end hour
                        splitTime = array.endtime!.split(separator: ":")
                        var endHour = Int(splitTime[0])
                        
                        if array.endtime!.contains("PM") {
                            endHour = endHour! + 12
                        }
                        
                    }
                    
                    

                    
                    //print(self.EventNames)
                    
                } catch {
                    print(error)
                }
                
                
                
                
    //          print(String(data: data, encoding: .utf8)!)
              semaphore.signal()
            }

            task.resume()
            semaphore.wait()
            
            
        }
    
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
               let start_time = jsonElement["starttime"] as? String,
               let endtime = jsonElement["endtime"] as? String,
               let entry_price = jsonElement["entryprice"] as? String,
               let descr = jsonElement["descr"] as? String,
               let phone_num = jsonElement["phonenum"] as? String
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
