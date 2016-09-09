//
//  Messages+CoreDataProperties.swift
//  Mecolab1
//
//  Created by rene Acuña Hernández on 27-06-16.
//  Copyright © 2016 rene Acuña Hernández. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Messages {

    @NSManaged var contenido: String?
    @NSManaged var tipo: NSNumber?
    @NSManaged var number: String?

}
