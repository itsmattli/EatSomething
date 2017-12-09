//
//  SecondViewController.swift
//  WheresDan
//
//  Created by Matthew Li on 2017-10-18.
//  Copyright © 2017 Matthew Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    let uid:String = Auth.auth().currentUser!.uid
    var pickerData:[String] = [String]()
    var ref = Database.database().reference()
    var selected: Int = 0


    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var isFemale: UISwitch!
    @IBOutlet weak var exercisePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exercisePicker.delegate = self
        self.exercisePicker.dataSource = self
        pickerData = ["Sedentary - no exercise",
            "Lightly Active - 1-3 times/week",
            "Moderatetely Active - 3-5 times/week",
            "Very Active - 6-7 times/week",
            "Extremely Active - 7+ times/week"]
        
        processInitialInfo()
        
        
    }

    func processInitialInfo(){
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            let age = value?["age"] as? Int ?? 25
            self.ageLabel.text = "Age: \(age)"
            self.ageSlider.value = Float(age)
            
            let height = value?["height"] as? Int ?? 175
            self.heightLabel.text = "Height (cm): \(height)"
            self.heightSlider.value = Float(height)
            
            let weight = value?["weight"] as? Int ?? 100
            self.weightLabel.text = "Age (pounds): \(weight)"
            self.weightSlider.value = Float(weight)
            
            
            let gender = value?["gender"] as? String ?? "F"
            if (gender == "F") {
                self.genderSwitch.setOn(true, animated: false)
            } else {
                self.genderSwitch.setOn(false, animated: false)
            }
            
            let indexActivity = value?["activity"] as? Int ?? 0
            self.exercisePicker.selectRow(indexActivity, inComponent: 0, animated: false)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func ageChanged(_ sender: UISlider) {
        ageLabel.text = "Age: \(Int(sender.value))"
    }
    
    @IBAction func weightChanged(_ sender: UISlider) {
        weightLabel.text = "Weight (Pounds): \(Int(sender.value))"
    }
    
    @IBAction func heightChanged(_ sender: UISlider) {
        heightLabel.text = "Height (cm): \(Int(sender.value))"
    }
    
    @IBAction func genderChanged(_ sender: UISwitch) {
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        let label = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = pickerData[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            self.selected = row
        }
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let gender = self.isFemale.isOn ? "F" : "M"
        self.ref.child("users").child(uid).setValue([
            "age"           : Int(self.ageSlider.value),
            "gender"        : gender,
            "weight"        : Int(self.weightSlider.value),
            "height"        : Int(self.heightSlider.value),
            "activity"      : self.selected
        ])
        let alertController = UIAlertController(title: "Success", message: "Profile Information Saved!", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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

