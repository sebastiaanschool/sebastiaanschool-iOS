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

open class Bulletin: Object, ReflectedStringConvertible {
    dynamic var title: String = ""
    dynamic var publishedAt: Date = Date()
    dynamic var body: String = ""
    dynamic var urlString: String = ""
    
    open override static func primaryKey() -> String? {
        return "urlString"
    }
}
