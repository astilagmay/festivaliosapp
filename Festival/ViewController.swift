//
//  ViewController.swift
//  Festival
//
//  Created by Asti Lagmay on 10/11/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // View Components
    @IBOutlet weak var UpcomingCView: UICollectionView!
    @IBOutlet weak var TodayCView: UICollectionView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var HappeningCView: UIView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var HappeningLabel: UILabel!
    @IBOutlet weak var TodayLabel: UILabel!
    @IBOutlet weak var UpcomingLabel: UILabel!
    
    //JSON structs
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
    var MyEventImages = [UIImage]()
    var MyEventNames = [String]()
    var MyEventDates = [String]()
    var MyEventLocs = [String]()
    var MyEventStart = [String]()
    var MyEventEnd = [String]()
    var MyEventPrices = [String]()
    @IBOutlet weak var NoUpcoming: UILabel!
    
    //Segue variables
    var passedName = String()
    var passedLoc = String()
    var passedDesc = String()
    var passedDate = String()
    var passedTime = String()
    var passedPrice = String()
    var passedImage = UIImage()
    
    //Now
    @IBOutlet weak var NoEventsNow: UILabel!
    @IBOutlet weak var NowEventPriceBox: UIView!
    @IBOutlet weak var NowEventPrice: UILabel!
    @IBOutlet weak var NowEventTime: UILabel!
    @IBOutlet weak var NowEventDate: UILabel!
    @IBOutlet weak var NowEventLoc: UILabel!
    @IBOutlet weak var NowEventName: UILabel!
    
    //Upcoming
    @IBOutlet weak var NoUpcomingEvents: UILabel!
    
    //get user defaults data
    func getLocalData() {
        
        //get local data
        let defaults = UserDefaults.standard
        let localNames = defaults.stringArray(forKey: "LocalNames") ?? [String]()
        let localDates = defaults.stringArray(forKey: "LocalDates") ?? [String]()
        let localLocs = defaults.stringArray(forKey: "LocalLocs") ?? [String]()
        let localStart = defaults.stringArray(forKey: "LocalStart") ?? [String]()
        let localEnd = defaults.stringArray(forKey: "LocalEnd") ?? [String]()
        let localPrices = defaults.stringArray(forKey: "LocalPrices") ?? [String]()
    
        //assign to upcoming arrays
        MyEventNames = localNames
        MyEventDates = localDates
        MyEventLocs = localLocs
        MyEventStart = localStart
        MyEventEnd = localEnd
        MyEventPrices = localPrices
        
        //add default image
        for _ in MyEventNames {
            self.MyEventImages.append(UIImage(named: "TodayEvent")!)
        }
        
        //check if no upcoming
        if (MyEventNames.count == 0) {
            NoUpcoming.isHidden = false
        }

         
        else {
            NoUpcoming.isHidden = true
        }
       
        
        
    }
    
    
    //GET request and parse to arrays
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
                
                //dictionary keys
                var i = 0;
                
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
                    
                    self.showAddButton[i] = 1
                    i = i + 1
                    
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
        
    
    var showAddButton = [Int:Int]()
    
    
    //add event button
    @IBAction func AddButton(_ sender: UIButton) {
        
        //add to upcoming arrays
        MyEventImages.append(EventImages[sender.tag])
        MyEventNames.append(EventNames[sender.tag])
        MyEventDates.append(EventDates[sender.tag])
        MyEventLocs.append(EventLocs[sender.tag])
        MyEventStart.append(EventStart[sender.tag])
        MyEventEnd.append(EventEnd[sender.tag])
        MyEventPrices.append(EventPrices[sender.tag])
        
        
        //hide add button
        showAddButton[sender.tag] = 0
        
        
        //check if no upcoming
        if (MyEventNames.count == 0) {
            NoUpcoming.isHidden = false
        }
        
            
        else {
            NoUpcoming.isHidden = true
        }
        
        //save to defaults
        let defaults = UserDefaults.standard
        defaults.set(MyEventNames, forKey: "LocalNames")
        defaults.set(MyEventDates, forKey: "LocalDates")
        defaults.set(MyEventLocs, forKey: "LocalLocs")
        defaults.set(MyEventStart, forKey: "LocalStart")
        defaults.set(MyEventEnd, forKey: "LocalEnd")
        defaults.set(MyEventPrices, forKey: "LocalPrices")
        
        //reload data
        self.UpcomingCView.reloadData()
        self.TodayCView.reloadData()
        
        
    }
    
    //segue to detailed info view
    @IBAction func SegueButton(_ sender: UIButton) {
        
        //set segue variables
        passedName = EventNames[sender.tag]
        passedLoc = EventLocs[sender.tag]
        passedDesc = EventDesc[sender.tag]
        passedDate = EventDates[sender.tag]
        passedTime = EventStart[sender.tag] + " - " + EventEnd[sender.tag]
        passedPrice = EventPrices[sender.tag]
        passedImage = EventImages[sender.tag]
        
        performSegue(withIdentifier: "showDetails", sender: nil)
        
    }
    
    //remove event
    @IBAction func RemoveButton(_ sender: UIButton) {
        
        //remove in upcoming arrays
        MyEventImages.remove(at: sender.tag)
        MyEventNames.remove(at: sender.tag)
        MyEventDates.remove(at: sender.tag)
        MyEventLocs.remove(at: sender.tag)
        MyEventStart.remove(at: sender.tag)
        MyEventEnd.remove(at: sender.tag)
        MyEventPrices.remove(at: sender.tag)
        
        
        //save to defaults
        let defaults = UserDefaults.standard
        defaults.set(MyEventNames, forKey: "LocalNames")
        defaults.set(MyEventDates, forKey: "LocalDates")
        defaults.set(MyEventLocs, forKey: "LocalLocs")
        defaults.set(MyEventStart, forKey: "LocalStart")
        defaults.set(MyEventEnd, forKey: "LocalEnd")
        defaults.set(MyEventPrices, forKey: "LocalPrices")
        
        
        //check if no upcoming
        if (MyEventNames.count == 0) {
          NoUpcoming.isHidden = false
        }

          
        else {
          NoUpcoming.isHidden = true
        }
        
        //show add button
        showAddButton[sender.tag] = 1
        
        //reload data
        self.UpcomingCView.reloadData()
        self.TodayCView.reloadData()
    }
    
    
    //set number of cells in collection views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == TodayCView) {
            return EventNames.count
        }
        
        else {
            return MyEventNames.count
        }
    }
    
    
    
    //initialize collection view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //events
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
        
            if (showAddButton[indexPath.row] == 1) {
                    cell.AddButton.isHidden = false
            }
            else {
                cell.AddButton.isHidden = true
            }
        
            cell.AddButton.tag = indexPath.row
            cell.AddButton.addTarget(self, action: #selector(self.AddButton), for: .touchUpInside)
        
            cell.SegueButton.tag = indexPath.row
            cell.SegueButton.addTarget(self, action: #selector(self.SegueButton), for: .touchUpInside)
            
            return cell
        }
        
        //upcoming events
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCollectionViewCell", for: indexPath) as! UpcomingCollectionViewCell
            
            cell.EventImage.image = MyEventImages[indexPath.row]
            cell.EventPrice.text = MyEventPrices[indexPath.row]
            cell.EventName.text = MyEventNames[indexPath.row]
            cell.EventLoc.text = MyEventLocs[indexPath.row]
            cell.EventDate.text = MyEventDates[indexPath.row]
            cell.EventTime.text = MyEventStart[indexPath.row] + " - " + EventEnd[indexPath.row]
            
            cell.RemoveButton.tag = indexPath.row
            cell.RemoveButton.addTarget(self, action: #selector(self.RemoveButton), for: .touchUpInside)
        
            return cell
            
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScrollView.delaysContentTouches = true
        ScrollView.canCancelContentTouches = true
        ScrollView.isUserInteractionEnabled = true
        ScrollView.isExclusiveTouch = true
        
        getInfo()
        getLocalData()
        
        /*
          ////////////////////
        //   For debugging   //
          ///////////////////
        */
 
        ScrollView.addSubview(UpcomingCView)
        
        
        print(ContentView.isUserInteractionEnabled)
        
        //notifications
        let notifCenter = UNUserNotificationCenter.current()

        //permission
        notifCenter.requestAuthorization(options: [.alert, .sound]) { (allowed, error) in
            if (!allowed) {
                print("Notifications not allowed")
            }
        }
        
        //content
        let notifContent = UNMutableNotificationContent()
        //notifContent.title = EVENT NAME
        //notifContent.body = TIME
        
        //trigger
        //---

        
        //request
        //---

        
        //ADD REQUEST ON ADDBUTTON FUNC AND REMOVE REQUEST ON REMOVEBUTTON FUNC
        
        TodayCView.frame.size = CGSize(width: TodayCView.collectionViewLayout.collectionViewContentSize.width, height: TodayCView.collectionViewLayout.collectionViewContentSize.height)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //check for current events happening
        
        var currentName: String?
        var currentLoc: String?
        var currentDate: String?
        var currentStart: String?
        var currentEnd: String?
        var currentPrice: String?
        var happening = 0
        var noUpcoming = 1
        
        
        //------------------------------------//
        //BLOCK OF CODE FOR VARIABLE HAPPENING//
        //   SET CURRENT VARIABLES HERE TOO   //
        //____________________________________//
        for i in 0..<EventDates.count{
            let dateString: String = EventDates[i]
            let startTimeString: String = EventStart[i]
            var endTimeString: String = EventEnd[i]
            
            if endTimeString == "N/A"{
                endTimeString = "11:59 PM"
            }
            
            let startDateString = dateString + ", " + startTimeString
            let endDateString = dateString + ", " + endTimeString
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let startDate = dateFormatter.date(from: startDateString)
            let endDate = dateFormatter.date(from: endDateString)
            let currDate = Date()
            
            if (currDate >= startDate! && currDate <= endDate!){
                happening = 1
                currentName = EventNames[i]
                currentLoc = EventLocs[i]
                currentDate = EventDates[i]
                currentStart = EventStart[i]
                currentEnd = EventEnd[i]
                currentPrice = EventPrices[i]
            }
            if (currDate < startDate!){
                noUpcoming = 0
            }
        }
        
        
        if (happening == 1) {
           DispatchQueue.main.async {
                self.NoEventsNow.isHidden = true
                self.NowEventName.text = currentName ?? "N/A"
                self.NowEventLoc.text = currentLoc ?? "N/A"
                self.NowEventDate.text = currentDate ?? "N/A"
                self.NowEventTime.text = (currentStart ?? "N/A") + " - " + (currentEnd ?? "N/A")
                self.NowEventPrice.text =  currentPrice ?? "N/A"
            
                self.NoEventsNow.isHidden = true
                self.NowEventName.isHidden = false
                self.NowEventLoc.isHidden = false
                self.NowEventDate.isHidden = false
                self.NowEventTime.isHidden = false
                self.NowEventPrice.isHidden = false
                self.NowEventPriceBox.isHidden = false
            }
        }
                        
        //no events happening right now
        else if (happening == 0) {
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
        
        if (noUpcoming == 1){
            DispatchQueue.main.async{
                self.NoUpcomingEvents.isHidden = false
            }
        }
        else if (noUpcoming == 0){
            DispatchQueue.main.async{
                self.NoUpcomingEvents.isHidden = true
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let destvc = segue.destination as! DetailedInfo
            
            destvc.passedName = passedName
            destvc.passedLoc = passedLoc
            destvc.passedDesc = passedDesc
            destvc.passedDate = passedDate
            destvc.passedTime = passedTime
            destvc.passedPrice = passedPrice
            destvc.passedImage = passedImage
        }
    }
    
    
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        // open search view to let the user search for the event
        self.performSegue(withIdentifier: "SearchView", sender: self)
    }
    

}

