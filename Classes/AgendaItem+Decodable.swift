//
//  AgendaItems+Decodable.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-05-16.
//
//

import Foundation
import SwiftyJSON
import JsonApiClient

extension AgendaItem : Decodable {
    public typealias DecodedType = AgendaItem
    
    public static func decode(json: JSON) -> Decoded<AgendaItem> {
        guard let title = json["title"].string else {
            return Decoded.Failure(DecodeError.MissingKey("title"))
        }
        
        guard let start = json["start"].string else {
            return Decoded.Failure(DecodeError.MissingKey("title"))
        }
        
        guard let startDate = jsonDateFormatter.dateFromString(start) else {
            return Decoded.Failure(DecodeError.TypeMismatch(expected: "Well formatted date string", actual: start))
        }
        
        guard let end = json["end"].string else {
            return Decoded.Failure(DecodeError.MissingKey("title"))
        }
        
        guard let endDate = jsonDateFormatter.dateFromString(end) else {
            return Decoded.Failure(DecodeError.TypeMismatch(expected: "Well formatted date string", actual: end))
        }
        
        guard let url = json["url"].URL else {
            return Decoded.Failure(DecodeError.MissingKey("title"))
        }

        return .Success(AgendaItem(title: title, start: startDate, end: endDate, url: url))
    }
}
