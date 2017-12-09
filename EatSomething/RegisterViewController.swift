//
//  RegisterViewController.swift
//  WheresDan
//
//  Created by Matthew Li on 2017-10-19.
//  Copyright © 2017 Matthew Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

   
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    var ref = Database.database().reference()
    
    @IBAction func register(_ sender: Any) {
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else if passwordTextField.text != confirmTextField.text {
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            let strSearch = self.emailTextField.text!
            ref.child("email").queryOrdered(byChild:  "email").queryStarting(atValue: strSearch).queryEnding(atValue: strSearch + "\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let alertController = UIAlertController(title: "Error", message: "Email already taken", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
             })
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    self.ref.child("users").child(user!.uid).setValue([
                        "email"         : self.emailTextField.text,
                        "age"           : nil,
                        "gender"        : nil,
                        "weight"        : nil,
                        "height"        : nil,
                        "activity"      : nil])
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        performSegue(withIdentifier: "RegisterToLogin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
