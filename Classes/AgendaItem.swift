//
//  AgendaItems.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-05-16.
//
//

import Foundation

import JsonApiClient
import RealmSwift

open class AgendaItem: Object, ReflectedStringConvertible {
    dynamic var title: String = ""
    dynamic var type: String = ""
    dynamic var start: Date?
    dynamic var end: Date?
    dynamic var urlString: String = ""
    
    override open static func primaryKey() -> String? {
        return "urlString"
    }
}


