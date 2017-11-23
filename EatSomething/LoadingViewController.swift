//
//  LoadingViewController.swift
//  EatSomething
//
//  Created by Matthew Li on 2017-11-22.
//  Copyright © 2017 Matthew Li. All rights reserved.
//

import UIKit
import Alamofire

class LoadingViewController: UIViewController {

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
                         "q" : query])
            .responseJSON { response in // 1
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        // Do any additional setup after loading the view.
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
