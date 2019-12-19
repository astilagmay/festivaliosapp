//
//  ViewController.swift
//  Festival
//
//  Created by Asti Lagmay on 10/11/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var UpcomingCView: UICollectionView!
    @IBOutlet weak var TodayCView: UICollectionView!
    
    var UpcomingImageArray = [UIImage(named: "UpcomingEvent"), UIImage(named: "UpcomingEvent"), UIImage(named: "UpcomingEvent"), UIImage(named: "UpcomingEvent"), UIImage(named: "UpcomingEvent"), UIImage(named: "UpcomingEvent")]
    
    var TodayImageArray = [UIImage(named: "TodayEvent"), UIImage(named: "TodayEvent"), UIImage(named: "TodayEvent"), UIImage(named: "TodayEvent"), UIImage(named: "TodayEvent"), UIImage(named: "TodayEvent")]
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        if (collectionView == TodayCView) {
            return TodayImageArray.count
        }
        
        else {
            return UpcomingImageArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == TodayCView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCollectionViewCell", for: indexPath) as! TodayCollectionViewCell
            
            cell.EventImage.image = TodayImageArray[indexPath.row]
            
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCollectionViewCell", for: indexPath) as! UpcomingCollectionViewCell
            
            cell.EventImage.image = UpcomingImageArray[indexPath.row]
            
            return cell
            
        }
       
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodayCView.frame.size = CGSize(width: TodayCView.collectionViewLayout.collectionViewContentSize.width,height: TodayCView.collectionViewLayout.collectionViewContentSize.height)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        // open search view to let the user search for the event
        self.performSegue(withIdentifier: "SearchView", sender: self)
    }
    

}

