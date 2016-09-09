//
//  Messages.swift
//  Mecolab1
//
//  Created by rene Acuña Hernández on 27-06-16.
//  Copyright © 2016 rene Acuña Hernández. All rights reserved.
//

import Foundation
import CoreData

//@objc(Messages)
class Messages: NSManagedObject {

    class func new(moc: NSManagedObjectContext, type:Int, content:String, number:String)->Messages{
        let newMessages = NSEntityDescription.insertNewObjectForEntityForName("Messages", inManagedObjectContext: moc) as! Mecolab1.Messages
        newMessages.tipo = type
        newMessages.contenido = content
        newMessages.number = number
        return newMessages
    }

}
