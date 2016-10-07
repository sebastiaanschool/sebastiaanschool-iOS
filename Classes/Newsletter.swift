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

open class Newsletter: Object, ReflectedStringConvertible {
    dynamic var title: String = ""
    dynamic var documentUrlString: String = ""
    dynamic var publishedAt: Date = Date()
    dynamic var urlString: String = ""

    open override static func primaryKey() -> String? {
        return "urlString"
    }
}
