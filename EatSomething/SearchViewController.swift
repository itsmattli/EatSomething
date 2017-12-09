//
//  SearchViewController.swift
//  WheresDan
//
//  Created by Matthew Li on 2017-10-20.
//  Copyright © 2017 Matthew Li. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase

class SearchViewController: UIViewController {
    @IBOutlet weak var queryText: UITextField!
    let uid:String = Auth.auth().currentUser!.uid
    var ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkUserProfile()
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
    
    func checkUserProfile() {
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary {
                if (value["age"] == nil
                    || value["height"] == nil
                    || value["weight"] == nil
                    || value["activity"] == nil) {
                        let alertController = UIAlertController(title: "Set Profile Information", message: "Please set your profile information before searching!", preferredStyle: .alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction!) in
                            self.performSegue(withIdentifier: "searchToProfile", sender: self)
                        }))
                        
                        
                        self.present(alertController, animated: true, completion: nil)
                }
            }
        })
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


