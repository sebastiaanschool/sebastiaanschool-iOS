//
//  ContactItem.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 28-08-16.
//
//

import Foundation

import JsonApiClient
import RealmSwift

public class ContactItem: Object, ReflectedStringConvertible {
    dynamic var displayName: String = ""
    dynamic var email: String = ""
    dynamic var order: Int = 0
    dynamic var detailText: String = ""
    dynamic var urlString: String = ""
    
    public override static func primaryKey() -> String? {
        return "urlString"
    }
}