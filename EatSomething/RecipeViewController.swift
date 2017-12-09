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
    var selectedIndex = 0;
    
    
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
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "recipeToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if (segue.identifier == "recipeToDetail") {
            // initialize new view controller and cast it as your view controller
            let detail = segue.destination as! DetailViewController
            // your new view controller should have property that will store passed value
            print("recipe")
            print(selectedIndex)
            print(self.filteredRecipes[selectedIndex])
            detail.recipe = self.filteredRecipes[selectedIndex]
        } else {
            print("segue didn't match")
        }
    }
}


