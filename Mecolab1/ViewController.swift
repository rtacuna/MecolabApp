//
//  ViewController.swift
//  Mecolab1
//
//  Created by rene Acuña Hernández on 14-06-16.
//  Copyright © 2016 rene Acuña Hernández. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
   
    @IBOutlet weak var textFieldNumber: UITextField!
    

    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func clear(){
        self.textFieldNumber.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func enter(sender: AnyObject) {
        let number = self.textFieldNumber.text
        if number != ""{
            self.clear()
            self.makeSignInRequest(number!)}
        
    }
    
    func makeSignInRequest(userNumber: String){
        
        let params: [String:String] = ["number":userNumber]
        let (session, request) = makeRequest(params, function: "signin")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard error == nil else{
                return print("Error")
            }
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            // analyze the information in the json
            let jsonSwift: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            // pass the json to a dictionary
            if let jsonDictionary = jsonSwift as? Dictionary<String, String>{
                if (statusCode == 200){
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(jsonDictionary["number"], forKey: "number")
                    defaults.synchronize()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
    


}

