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
    let title: String
    let start: NSDate
    let end: NSDate
    let url: NSURL
    
    public init(title: String, start: NSDate, end: NSDate, url: NSURL) {
        self.title = title
        self.start = start
        self.end = end
        self.url = url
    }
}