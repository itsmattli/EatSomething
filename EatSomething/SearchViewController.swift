//
//  SearchViewController.swift
//  WheresDan
//
//  Created by Matthew Li on 2017-10-20.
//  Copyright © 2017 Matthew Li. All rights reserved.
//
import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController {
    @IBOutlet weak var queryText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        if(queryText.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Please enter something in the search box", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "SearchToLoading", sender: self)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SearchToLoading") {
            let loading = segue.destination as! LoadingViewController
            let query = queryText.text
            loading.queryText = query
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


