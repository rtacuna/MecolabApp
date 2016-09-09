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
    var tupla = (String(),String())
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //CoreData
    var mensajesManager = MessagesManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FecthContact
        mensajesManager.fetchContacts(tupla.1)
        
        //Table
        tableView2.delegate = self
        tableView2.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func send(sender: AnyObject) {
        let mensaje = mensajeField.text
        if mensaje != ""{
            self.clear()
            self.sendMessage(mensaje!)
        }
    }
    
    func clear(){
        mensajeField.text = ""
    }
    
    func sendMessage(mensaje: String) {
        // 1. Create HTTP request and set request header
        
        let numero = defaults.objectForKey("number") as! String
        let params = ["number": numero, "contact":self.tupla.1, "message": mensaje]
        let (session, request) = makeRequest(params, function: "messages")
        
        //Send de request
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            print(error)
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            print(statusCode)
            if (statusCode == 200) {
                print("Mensaje enviado")
                self.addMensaje(mensaje, who: 1)

            }
        }
        
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mensajesManager.messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        if mensajesManager.messages[indexPath.row].tipo == 1 {
            cell.textLabel?.textAlignment = .Right
        }
        else{
            cell.textLabel?.textAlignment = .Left
        }
        cell.textLabel?.text = mensajesManager.messages[indexPath.row].contenido
        
        return cell
    }
    
    func addMensaje(mensaje:String, who:Int) {
        let numero = tupla.1
        mensajesManager.addNewContact(who, contenido: mensaje, number: numero)
        mensajesManager.fetchContacts(numero)
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView2.reloadData()
        }
    }
    

}
