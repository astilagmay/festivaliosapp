//
//  SearchView.swift
//  Festival
//
//  Created by Hale Pascua on 19/12/2019.
//  Copyright © 2019 Asti Lagmay. All rights reserved.
//

import UIKit

class SearchView: UIViewController, HomeModelProtocol{
    @IBOutlet var searchViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var eventItems: NSArray = NSArray()
    var origEventData: [String] = []
    var currEventData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchViewContainer.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
    
        tableView.delegate = self
        tableView.dataSource = self
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems_Events()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // functions to get the data
    func itemsDownloaded(items: NSArray) {
        eventItems = items
    }
    
    func loadOrigData(){
        for event in eventItems{
            origEventData.append((event as! EventModel).name! + " (" + (event as! EventModel).date! + ")")
        }
    }
    
    func filterData (searchTerm: String){
        if searchTerm.count > 0{
            currEventData = origEventData
            let results = currEventData.filter { $0.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased()) }
            currEventData = results
            tableView.reloadData()
        }
    }
    
    func restoreData(){
        currEventData = origEventData
        tableView.reloadData()
    }
}

extension SearchView: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterData(searchTerm: searchText)
        }
    }
}

extension SearchView: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        
        if let searchText = searchController.searchBar.text{
            filterData(searchTerm: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty{
            restoreData()
        }
    }
}

extension SearchView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Selection", message: "Selected: \(currEventData[indexPath.row])", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        searchController.isActive = false
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currEventData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = currEventData[indexPath.row]
        return cell
    }
}
