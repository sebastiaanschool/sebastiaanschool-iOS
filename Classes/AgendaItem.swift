//
//  AgendaItems.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-05-16.
//
//

import Foundation
import JsonApiClient

public class AgendaItem: ReflectedStringConvertible {
    dynamic var title: String = ""
    dynamic var type: String = ""
    dynamic var start: NSDate?
    dynamic var end: NSDate?
    dynamic var urlString: String = ""
}