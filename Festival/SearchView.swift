//
//  SearchView.swift
//  Festival
//
//  Created by Hale Pascua on 19/12/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import UIKit

class SearchView: UIViewController{
    
    @IBOutlet var searchViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    
    var searchController: UISearchController!
    
    // TableView Data
    var origEventData: [String] = []
    var currEventData: [String] = []
    var origIndices: [Int] = []
    var filteredIndices: [Int] = []
    
    var homeModel = HomeModel()
    
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

        homeModel.getInfo()
        self.loadOrigData()
        currEventData = origEventData
        filteredIndices = origIndices
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.allowsSelectionDuringEditing = true
        tableView.canCancelContentTouches = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func loadOrigData(){
        for i in 0..<homeModel.EventNames.count{
            origEventData.append(homeModel.EventNames[i] + " (" +  homeModel.EventDates[i] + ")")
            origIndices.append(i)
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

}

extension SearchView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currEventData = origEventData
        filteredIndices = origIndices
        
        if searchText.isEmpty == false{
            let result = currEventData.filter { $0.replacingOccurrences(of: " ", with: "").lowercased().contains(searchText.replacingOccurrences(of: " ", with: "").lowercased()) }
            
            filteredIndices = currEventData.indices.filter{ currEventData[$0].replacingOccurrences(of: " ", with: "").lowercased().contains(searchText.replacingOccurrences(of: " ", with: "").lowercased()) }
            
            currEventData = result
        }
        
        tableView.reloadData()
        
        //print(currEventData.count)
        //print(filteredIndices)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableViewConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        tableView.isHidden = false
    }
}

extension SearchView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currEventData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = currEventData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passedName = homeModel.EventNames[filteredIndices[indexPath.row]]
        passedLoc = homeModel.EventLocs[filteredIndices[indexPath.row]]
        passedDate = homeModel.EventDates[filteredIndices[indexPath.row]]
        passedDesc = homeModel.EventDesc[filteredIndices[indexPath.row]]
        passedTime = homeModel.EventStart[filteredIndices[indexPath.row]]
        passedImage = homeModel.EventImages[filteredIndices[indexPath.row]]
        passedPrice = homeModel.EventPrices[filteredIndices[indexPath.row]]
        
        // FOR DEBUGGING
        //print(indexPath.row)
        //print(filteredIndices[indexPath.row])
        //print(passedName + " " + passedDate)
        
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}
