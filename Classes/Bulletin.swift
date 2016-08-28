//
//  Bulletin.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 19-05-16.
//
//

import Foundation

import JsonApiClient
import RealmSwift

public class Bulletin: Object, ReflectedStringConvertible {
    dynamic var title: String = ""
    dynamic var publishedAt: NSDate = NSDate()
    dynamic var body: String = ""
    dynamic var urlString: String = ""
    
    public override static func primaryKey() -> String? {
        return "urlString"
    }
}