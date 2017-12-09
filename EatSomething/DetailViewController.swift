//
//  DetailViewController.swift
//  EatSomething
//
//  Created by Matthew Li on 2017-12-08.
//  Copyright © 2017 Matthew Li. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController {
    var recipe: Recipe?
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var calories: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkImage()
        self.checkName()
        self.checkCalories()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func calcaulateClicked(_ sender: Any) {
        performSegue(withIdentifier: "detailToIngredients", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailToIngredients") {
            let ingredient = segue.destination as! IngredientViewController
            ingredient.recipe = self.recipe
        }
    }
    func checkImage() {
        if let imageUrl = self.recipe?.image {
            Alamofire.request(imageUrl).responseImage { response in
                if let image = response.result.value {
                    self.recipeImage.image = image
                    
                }
            }
        }
    }
    
    func checkName() {
        if let name = self.recipe?.label {
            recipeName.text = name
        }
    }
    
    func checkCalories() {
        if let cal = self.recipe?.calories {
            if let yield = self.recipe?.yield {
                self.calories.text = "\(Int(Double(cal)/Double(yield))) per serving"
            } else {
                self.calories.text = "\(Int(cal))"
            }
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        performSegue(withIdentifier: "detailToSearch", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
