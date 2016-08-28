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

public class Newsletter: Object, ReflectedStringConvertible {
    dynamic var title: String = ""
    dynamic var documentUrlString: String = ""
    dynamic var publishedAt: NSDate = NSDate()
    dynamic var urlString: String = ""

    public override static func primaryKey() -> String? {
        return "urlString"
    }
}