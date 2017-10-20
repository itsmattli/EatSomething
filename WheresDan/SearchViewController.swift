//
//  SearchViewController.swift
//  WheresDan
//
//  Created by Matthew Li on 2017-10-20.
//  Copyright © 2017 Matthew Li. All rights reserved.
//
import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var filteredUsers = [User]()
    
    struct User {
        var name = String()
        var uid = String()
        var email = String()
        var address = String()
        
    }
    
    var users = [User(name: "Red Velvet", uid: "ausdfhajksfjkas", address: "Small"),
                 User(name: "fadsfads", uid: "ausdfhajksfjkas", address: "Smaadfall")]
                 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.users[indexPath.row].name
        cell.detailTextLabel?.text = "\(self.users[indexPath.row].uid) \(self.users[indexPath.row].address)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }
    
}
