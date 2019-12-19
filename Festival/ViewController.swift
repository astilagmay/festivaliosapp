//
//  ViewController.swift
//  Festival
//
//  Created by Asti Lagmay on 10/11/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var UpcomingCView: UICollectionView!
    @IBOutlet weak var TodayCView: UICollectionView!
    
    
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
    
    
    //Today and Upcoming
    var EventImages = [UIImage]()
    var EventNames = [String]()
    var EventDates = [String]()
    var EventLocs = [String]()
    var EventStart = [String]()
    var EventEnd = [String]()
    var EventPrices = [String]()
    var EventDesc = [String]()
    var EventPhone = [String]()
    
    //My
    var MyEventImages = [String]()
    var MyEventNames = [String]()
    var MyEventDates = [String]()
    var MyEventLocs = [String]()
    var MyEventStart = [String]()
    var MyEventEnd = [String]()
    var MyEventPrices = [String]()
    
    //Now
    @IBOutlet weak var NoEventsNow: UILabel!
    @IBOutlet weak var NowEventPriceBox: UIView!
    @IBOutlet weak var NowEventPrice: UILabel!
    @IBOutlet weak var NowEventTime: UILabel!
    @IBOutlet weak var NowEventDate: UILabel!
    @IBOutlet weak var NowEventLoc: UILabel!
    @IBOutlet weak var NowEventName: UILabel!
    
    var UpcomingImageArray = [UIImage]()
    
    func getTimeDiff(time1: String, time2: String) -> Int {
        

        
        
        
        
    }

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
                
                let date = Date()
                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyyy-MM-dd"
                
                let currentDate = formatter.string(from: date)
                
                formatter.dateFormat = "HH"
                let currentHour = Int(formatter.string(from: Date()))

//                print(currentHour!)
                
                var happening = 0;

                
                //loop through whole array
                for array in parsedData.data {
                    
                    
                    
                    //get all events
                    self.EventImages.append(UIImage(named: "TodayEvent")!)
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
                    
                    
                    //check for events happening right now
                    if (array.date == currentDate) {
                        if (currentHour! >= startHour! && currentHour! <= endHour!) {
                            
                            happening = 1
                            
    //                        print(currentHour! - eventHour!)

                           DispatchQueue.main.async {
                                self.NoEventsNow.isHidden = true
                                self.NowEventName.text = array.name ?? "N/A"
                                self.NowEventLoc.text = array.venue ?? "N/A"
                                self.NowEventDate.text = array.date ?? "N/A"
                                self.NowEventTime.text = (array.starttime ?? "N/A") + " - " + (array.endtime ?? "N/A")
                                self.NowEventPrice.text =  array.entryprice ?? "N/A"
                            
                                self.NoEventsNow.isHidden = true
                                self.NowEventName.isHidden = false
                                self.NowEventLoc.isHidden = false
                                self.NowEventDate.isHidden = false
                                self.NowEventTime.isHidden = false
                                self.NowEventPrice.isHidden = false
                                self.NowEventPriceBox.isHidden = false
                            }
                        }
                    }
                    
                    //no events happening right now
                    if (happening == 0) {
                        DispatchQueue.main.async {
                            self.NoEventsNow.isHidden = false
                            self.NowEventName.isHidden = true
                            self.NowEventLoc.isHidden = true
                            self.NowEventDate.isHidden = true
                            self.NowEventTime.isHidden = true
                            self.NowEventPrice.isHidden = true
                            self.NowEventPriceBox.isHidden = true
                        }
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
        
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        if (collectionView == TodayCView) {
//
//            if (EventNames.count == 0) {
//                return 1
//            }
            
            return EventNames.count
        }
        
        else {
//            
//            if (MyEventNames.count == 0) {
//                return 1
//            }
//            
            return MyEventNames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == TodayCView) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell", for: indexPath) as! TodayCollectionViewCell
            
                cell.EventImage.image = EventImages[indexPath.row]
                cell.EventPrice.text = EventPrices[indexPath.row]
                cell.EventName.text = EventNames[indexPath.row]
                cell.EventLocation.text = EventLocs[indexPath.row]
                cell.EventDate.text = EventDates[indexPath.row]
                cell.EventTime.text = EventStart[indexPath.row] + " - " + EventEnd[indexPath.row]
                cell.EventDescription.text = EventDesc[indexPath.row]
                cell.NoEvents.isHidden = true
                
                return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCollectionViewCell", for: indexPath) as! UpcomingCollectionViewCell
            
//            cell.EventImage.image = UpcomingImageArray[indexPath.row]
//            cell.EventPrice.text = EventPrices[indexPath.row]
//            cell.EventName.text = EventNames[indexPath.row]
//            cell.EventLoc.text = EventLocs[indexPath.row]
//            cell.EventDate.text = EventDates[indexPath.row]
//            cell.EventTime.text = EventStart[indexPath.row] + " - " + EventEnd[indexPath.row]
            
            return cell
            
        }
               
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getInfo()
        


        
        TodayCView.frame.size = CGSize(width: TodayCView.collectionViewLayout.collectionViewContentSize.width,height: TodayCView.collectionViewLayout.collectionViewContentSize.height)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        // open search view to let the user search for the event
        self.performSegue(withIdentifier: "SearchView", sender: self)
    }
    

}

