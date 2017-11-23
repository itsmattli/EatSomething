//
//  SearchViewController.swift
//  WheresDan
//
//  Created by Matthew Li on 2017-10-20.
//  Copyright © 2017 Matthew Li. All rights reserved.
//
import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
 
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)

    
    struct User {
        var name = String()
        var address = String()
        
    }
    let ref = Database.database().reference(withPath: "users")
    var filteredUsers = [User]()
    var users = [User]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.observe(.value, with: { snapshot in
            // 2
            var newUsers = [User]()
            
            // 3
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let value = rest.value as? NSDictionary
                let name = value?["username"] as? String ?? ""
                let address = value?["address"] as? String ?? ""
                let newUser = User(name: name, address: address)
                newUsers.append(newUser)
            }
            
            // 5
            self.users = newUsers
            self.filteredUsers = self.users
            self.tableView.reloadData()
        });
        filteredUsers = users
        
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            self.filteredUsers = self.users
        } else {
            // Filter the results
            self.filteredUsers = self.users.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.filteredUsers.count)
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


