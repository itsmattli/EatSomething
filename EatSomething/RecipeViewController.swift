//
//  RecipeController.swift
//  EatSomething
//
//  Created by Matthew Li on 2017-11-22.
//  Copyright © 2017 Matthew Li. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
  
    @IBOutlet weak var tableView: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var filteredRecipes = [Recipe]()
    var recipes = [Recipe]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filteredRecipes = self.recipes
        self.tableView.reloadData()
        
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
            self.filteredRecipes = self.recipes
        } else {
            // Filter the results
            self.filteredRecipes = self.recipes.filter { $0.label.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.filteredRecipes[indexPath.row].label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }
}


