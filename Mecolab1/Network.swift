//
//  Network.swift
//  Mecolab1
//
//  Created by rene Acuña Hernández on 7/2/16.
//  Copyright © 2016 rene Acuña Hernández. All rights reserved.
//

//import Foundation
import Contacts
    
func makeRequest(params: [String:String], function:String) -> (NSURLSession, NSMutableURLRequest) {
        // specify the route
        let route = "http://192.168.0.31:3000/users"
        let url = NSURL(string: "\(route)/\(function)")
    
        // Create de NSURLSession
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        // specify the method
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
        }
        catch {
            
        }
        return (session, request)
}
    
    func makeStringContacts() -> String {
        var contacts = ""
        let store = CNContactStore()
        let keysToFetch = [CNContactPhoneNumbersKey]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try store.containersMatchingPredicate(nil)
        } catch {
            print("No Accediste a los contactos")
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
            do {
                let containerResults = try store.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch: keysToFetch)
                results.appendContentsOf(containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        for result in results{
            for number in result.phoneNumbers{
                let num = (number.value as! CNPhoneNumber).valueForKey("digits") as! String
                contacts = contacts + "," + num
                
            }
        }
        return contacts
    }
    
