//
//  IngredientViewController.swift
//  EatSomething
//
//  Created by Matthew Li on 2017-12-08.
//  Copyright © 2017 Matthew Li. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseAuth
import FirebaseDatabase


struct Ingredient {
    var name: String
    var weight: Int
    var text: String
}

class IngredientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let uid:String = Auth.auth().currentUser!.uid
    var ref = Database.database().reference()
    var recipe:Recipe?
    var url:String?
    var age:Int?
    var gender:String?
    var weight:Int?
    var height:Int?
    var activity:Int?
    var mealCal:Double?
    var ingredients: [Ingredient] = [Ingredient]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculate()
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func backToSearch(_ sender: Any) {
        performSegue(withIdentifier: "ingredientsToSearch", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") as! IngredientTableViewCell
        
        cell.name?.text = self.ingredients[indexPath.row].name
        cell.weight?.text = "\(self.ingredients[indexPath.row].weight) grams"
        cell.label?.text = self.ingredients[indexPath.row].text
        
        return cell
    }
    
    @IBAction func linkClicked(_ sender: Any) {
        if let url = URL(string: self.url!) {
            UIApplication.shared.open(url, options: [ : ], completionHandler: nil)
        }
    }
    
    func calculate() {
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary {
                self.age = value["age"] as! Int
                self.gender = value["gender"] as! String
                self.weight = value["weight"] as! Int
                self.height = value["height"] as! Int
                self.activity = value["activity"] as! Int
                
                
                if self.gender == "M" {
                    self.calculateMen()
                } else {
                    self.calculateWomen()
                }
            }
        })
    }
    
    func calculateWomen() {
        let weightFactor = 4.35 * Double(self.weight!)
        let heightFactor = 4.7 * Double(self.height!) / 2.54
        let ageFactor = 4.7 * Double(self.age!)
        let bmr = 655 + weightFactor + heightFactor - ageFactor
        let dailyCal = factorActivity(bmr: bmr)
        print(dailyCal)
        self.mealCal = dailyCal / 2
        self.processDisplay()
    }
    
    func calculateMen() {
        let weightFactor =  6.23 * Double(self.weight!)
        let heightFactor = 12.7 * Double(self.height!) / 2.54
        let ageFactor = 6.8 * Double(self.age!)
        let bmr = 066 + weightFactor + heightFactor - ageFactor
        let dailyCal: Double = factorActivity(bmr: bmr)
        print(dailyCal)
        self.mealCal = dailyCal / 2
        self.processDisplay()
    }
    
    func factorActivity(bmr: Double) -> Double {
        var dailyCal: Double = 0.0
        switch (self.activity) {
        case 0?:
            dailyCal = bmr * 1.2
            break
        case 1?:
            dailyCal = bmr * 1.375
            break
        case 2?:
            dailyCal = bmr * 1.55
            break
        case 3?:
            dailyCal = bmr * 1.725
            break
        case 4?:
            dailyCal = bmr * 1.9
            break
        default:
            break
        }
        return dailyCal
    }

    
    func processDisplay() {
        if let recipe = self.recipe {
            self.url = recipe.url
            let calPerYield = Double(recipe.calories)/Double(recipe.yield)
            var mealRatio = self.mealCal! / calPerYield
            print(self.mealCal)
            print(mealRatio)
            print(calPerYield)
            if mealRatio < 1 {
               mealRatio = 1
            }
            self.name.text = recipe.label
            var newIngredients = [Ingredient]()
            
            for ingredient in recipe.ingredients.arrayValue {
                let ingredientWeight = Int(Double(ingredient["weight"].int!) / recipe.yield  * mealRatio * 5)
                let ingredientName = ingredient["food"].string!
                let ingredientText = ingredient["text"].string!
                let newIngredient = Ingredient(name: ingredientName, weight: ingredientWeight, text: ingredientText)
                newIngredients.append(newIngredient)
            }
            self.ingredients = newIngredients
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
        } else {
            // Alert the user that there is no internet connection
            let alert = UIAlertController(title: "No Internet Connection!", message: "App may not function properly", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

}
