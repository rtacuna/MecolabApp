//
//  NewUserViewController.swift
//  Mecolab1
//
//  Created by rene Acuña Hernández on 14-06-16.
//  Copyright © 2016 rene Acuña Hernández. All rights reserved.
//

import UIKit
import ContactsUI

class NewUserViewController: UIViewController {


    @IBOutlet weak var textFieldName: UITextField!

    @IBOutlet weak var textFieldNumber: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func newUser(sender: AnyObject) {
        let nombre = self.textFieldName.text
        let number = self.textFieldNumber.text
        let password = self.textFieldPassword.text
        
        // Check if the field have something
        if nombre != "" && number != "" && password != ""{
            self.clear()
            makeSignUpRequest(nombre!, userNumber: number!, userPassword: password!)
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clear(){
        self.textFieldName.text = ""
        self.textFieldNumber.text = ""
        self.textFieldPassword.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func makeSignUpRequest(userName:String, userNumber:String, userPassword:String){

        let contactos = makeStringContacts()
        let params = ["full_name": userName, "number":userNumber, "password":userPassword, "contactos":contactos]
        let (session, request) = makeRequest(params, function: "signup")

        let conextion = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard error == nil else{
                return print("Error")
            }
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            // verifies that there is no error
            if (statusCode == 200) {
                // return to the view controller
                self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        conextion.resume()
    }

    


}
