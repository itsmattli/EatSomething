//
//  CreateTableViewController.swift
//  WheresDan
//
//  Created by Matthew Li on 2017-11-10.
//  Copyright © 2017 Matthew Li. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    struct User {
        var name = String()
        var uid = String()
        var address = String()
        
    }
    
    var filteredUsers = [User]()
    var users = [User(name: "Niko", uid: "ausdfhajksfjkas", address: "Peer Tutor Area"),
                 User(name: "Kate", uid: "ausdfhajksfjkas", address: "Boston Pizza"),
                 User(name: "Vincent", uid: "adsfasdfads", address: "Garbage Island")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredUsers = users
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredUsers = users
        } else {
            // Filter the results
            filteredUsers = users.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.filteredUsers[indexPath.row].name
        cell.detailTextLabel?.text = self.filteredUsers[indexPath.row].address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }
}

