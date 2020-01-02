//
//  DetailedInfo.swift
//  Festival
//
//  Created by Asti Lagmay on 20/12/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import UIKit

class DetailedInfo: UIViewController {
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventLoc: UILabel!
    @IBOutlet weak var EventDesc: UILabel!
    @IBOutlet weak var EventDate: UILabel!
    @IBOutlet weak var EventTime: UILabel!
    @IBOutlet weak var EventPrice: UILabel!
    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    //Segue variables
    var passedName = String()
    var passedLoc = String()
    var passedDesc = String()
    var passedDate = String()
    var passedTime = String()
    var passedPrice = String()
    var passedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventName.text = passedName
        EventLoc.text = passedLoc
        EventDesc.text = passedDesc
        EventDate.text = passedDate
        EventTime.text = passedTime
        EventPrice.text = passedPrice
        EventImage.image = passedImage

        // Do any additional setup after loading the view.
    //ScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: EventDesc.bottomAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
