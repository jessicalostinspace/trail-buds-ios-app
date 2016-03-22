//
//  User.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/21/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//
//
import Foundation
import RealmSwift

class User: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var name = ""
    dynamic var id = ""
    dynamic var city = ""
    dynamic var state = ""
    dynamic var email = ""
    dynamic var password = ""
    dynamic var birthday = ""
    dynamic var createdAt = NSDate()
    
}
