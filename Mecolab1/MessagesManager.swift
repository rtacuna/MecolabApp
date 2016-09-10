//
//  MessagesManager.swift
//  Mecolab1
//
//  Created by rene Acuña Hernández on 27-06-16.
//  Copyright © 2016 rene Acuña Hernández. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class MessagesManager{
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var messages = [Messages]()
    
    
    func addNewContact(typo:Int, content:String, number:String){
        _ = Messages.new(moc, type: typo, content: content, number: number)
        saveDatabase()
    }
    
    func saveDatabase(){
        do{
            try moc.save()
        } catch{
            
        }
    }
    func fetchContacts(number:String){
        // select only the messages with the number in the params
        let predicateFirstName = NSPredicate(format: "number == %@", number)
        let fetchRequest = NSFetchRequest(entityName: "Messages")
        fetchRequest.predicate = predicateFirstName
        // save in mensajes the fetchResults
        if let fetchResults = (try? moc.executeFetchRequest(fetchRequest)) as? [Messages] {
            messages = fetchResults
        }
    }
    
}