//
//  ContactsViewController.swift
//  Mecolab1
//
//  Created by rene Acuña Hernández on 14-06-16.
//  Copyright © 2016 rene Acuña Hernández. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var contact:[(name: String, number: String)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.objectForKey("number") == nil {
            retornan()}
        else{
            self.makeContactsRequest()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func retornan() {
        if let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController {
            // only if you have a navigationController
            self.navigationController?.presentViewController(loginController, animated: true, completion: nil)
        }
    }
    
    func makeContactsRequest(){
        let numero = defaults.objectForKey("number") as! String
        let params = ["number": numero]
        let (session, request) = makeRequest(params, function: "list_contacts")

        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard error == nil else{
                return print("Error")
            }
            let jsonSwift: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            if let jsonDiccionario = jsonSwift as? Array<AnyObject>{
                for elemento in jsonDiccionario{
                    let name = elemento["full_name"] as! String
                    let number = elemento["number"] as! String

                    // Save the contacts
                    self.contact.append((name: name, number: number))
                }
                // to load the table
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contact.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.contact[indexPath.row].name

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("detail", sender: indexPath.row)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "detail" {
            let detailView = segue.destinationViewController as? ChatViewController
            if let index = sender as? Int {
                detailView?.tupla = self.contact[index]
            }
        }
    }
    
    @IBAction func toLogin(sender: AnyObject) {
            defaults.setObject(nil, forKey: "number")
            defaults.synchronize()
            retornan()
    }
    
    @IBAction func refreshContacts(sender: AnyObject) {
        contact = []
        self.makeContactsRequest()
    }


}
