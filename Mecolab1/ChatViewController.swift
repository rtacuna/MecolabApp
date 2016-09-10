//
//  ChatViewController.swift
//  Mecolab1
//
//  Created by rene Acuña Hernández on 27-06-16.
//  Copyright © 2016 rene Acuña Hernández. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Labels and Fields
    @IBOutlet weak var mensajeField: UITextField!
    
    //Table
    @IBOutlet weak var tableView2: UITableView!
    
    //Local Varaible
    var tuple = (String(),String())
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //CoreData
    var messagesManager = MessagesManager()
    
    // Push Notification
    static let RefreshNewsFeedNotification = "Messages"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FecthContact
        messagesManager.fetchContacts(tuple.1)
        
        //Table
        tableView2.delegate = self
        tableView2.dataSource = self
        
        //Observer
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.receivedRefreshNewsFeedNotification(_:)), name: ChatViewController.RefreshNewsFeedNotification, object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        //Scroll to botton
        scrollTableView()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func scrollTableView()  {
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.tableView2.reloadData()
            if self.messagesManager.messages.count > 0 {
                self.scrollToBottomMessage()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receivedRefreshNewsFeedNotification(notification: NSNotification) {
        messagesManager.fetchContacts(tuple.1)
        scrollTableView()
    }

    
    @IBAction func send(sender: AnyObject) {
        let message = mensajeField.text
        if message != ""{
            self.clear()
            self.sendMessage(message!)
        }
        view.endEditing(true)
    }
    
    func clear(){
        mensajeField.text = ""
    }
    
    func sendMessage(message: String) {
        // 1. Create HTTP request and set request header
        
        let number = defaults.objectForKey("number") as! String
        let params = ["number": number, "contact":self.tuple.1, "message": message]
        let (session, request) = makeRequest(params, function: "messages")
        
        //Send de request
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                print("Message Correct")
                self.addMensaje(message, who: 1)

            }
        }
        
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesManager.messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        view.endEditing(true)
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        if messagesManager.messages[indexPath.row].tipo == 1 {
            cell.textLabel?.textAlignment = .Right
        }
        else{
            cell.textLabel?.textAlignment = .Left
        }
        cell.textLabel?.text = messagesManager.messages[indexPath.row].contenido
        return cell
    }
    
    func addMensaje(message:String, who:Int) {
        let number = tuple.1
        messagesManager.addNewContact(who, content: message, number: number)
        messagesManager.fetchContacts(number)
        scrollTableView()
    }
    
    //Scroll to the botton
    func scrollToBottomMessage() {
        let bottomMessageIndex = NSIndexPath(forRow: self.tableView2.numberOfRowsInSection(0) - 1, inSection: 0)
        self.tableView2.scrollToRowAtIndexPath(bottomMessageIndex, atScrollPosition: .Bottom,animated: true)
    }
    
    

    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }

}
