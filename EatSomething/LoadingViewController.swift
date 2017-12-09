//
//  LoadingViewController.swift
//  EatSomething
//
//  Created by Matthew Li on 2017-11-22.
//  Copyright © 2017 Matthew Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Recipe {
    var label: String
    var image: String
    var url: String
    var calories: Double
    var yield: Double
    var ingredients: JSON
}

class LoadingViewController: UIViewController {
    var recipes = [Recipe]()
    let baseURL: String = "https://api.edamam.com/search"
    @IBOutlet weak var resultsView: UITextView!
    var queryText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query:String = (queryText == nil) ? "" : queryText!
        Alamofire.request(
            URL(string: baseURL)!,
            method: .get,
            parameters: ["api_key" : "1d88b9f8",
                         "to" : 50,
                         "q" : query])
            .responseJSON { response in // 1
                let data = JSON(response.result.value as Any)
                let hits = data["hits"]
                
                if (data["hits"].count == 0) {
                    let alertController = UIAlertController(title: "Error", message: "No results found.", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction!) in
                        self.performSegue(withIdentifier: "loadingToSearch", sender: self)
                    }))
                
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
                var searchedRecipes = [Recipe]()
                for hit in hits.arrayValue {
                    let newRec = Recipe(
                        label: hit["recipe"]["label"].string!,
                        image: hit["recipe"]["image"].string!,
                        url: hit["recipe"]["url"].string!,
                        calories: hit["recipe"]["calories"].double!,
                        yield: hit["recipe"]["yield"].double ?? 1,
                        ingredients: hit["recipe"]["ingredients"])
                    searchedRecipes.append(newRec);
                }
                self.recipes = searchedRecipes
                self.performSegue(withIdentifier: "LoadingToRecipe", sender: self)
            }
        // Do any additional setup after loading the view.
    }
    
    func setRecipes(searchedRecipes: [Recipe]) {
        self.recipes = searchedRecipes
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoadingToRecipe" {
            if let DVC = segue.destination as? RecipeViewController{
                DVC.recipes = self.recipes
            } else {
                print("Data NOT Passed! destination vc is not set to firstVC")
            }
        } else { print("Id doesnt match with Storyboard segue Id") }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
