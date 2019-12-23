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
    
    var origEventData: [String] = []
    var currEventData: [String] = []
    
    var homeModel = HomeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeModel.getInfo()
        self.loadOrigData()
        currEventData = origEventData
        
        tableView.dataSource = self
        tableView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func loadOrigData(){
        for event in homeModel.EventNames{
            origEventData.append(event)
        }
    }

}

extension SearchView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currEventData = origEventData
        
        if searchText.isEmpty == false{
            let result = origEventData.filter { $0.replacingOccurrences(of: " ", with: "").lowercased().contains(searchText.replacingOccurrences(of: " ", with: "").lowercased()) }
            
            currEventData = result
        }
        
        tableView.reloadData()
        
        //print(currEventData.count)
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
}
