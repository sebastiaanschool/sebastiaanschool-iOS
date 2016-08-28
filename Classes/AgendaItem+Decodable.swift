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
        let agendaItem = AgendaItem()
        agendaItem.title = json["title"].stringValue
        if let dateString = json["start"].string {
            agendaItem.start = jsonDateFormatter.dateFromString(dateString)
        }

        guard let start = json["start"].string else {
            return Decoded.Failure(DecodeError.MissingKey("start"))
        }
        guard let startDate = jsonDateFormatter.dateFromString(start) else {
            return Decoded.Failure(DecodeError.TypeMismatch(expected: "Well formatted date string", actual: start))
        }
        
        agendaItem.start = startDate

        guard let end = json["end"].string else {
            return Decoded.Failure(DecodeError.MissingKey("end"))
        }
        guard let endDate = jsonDateFormatter.dateFromString(end) else {
            return Decoded.Failure(DecodeError.TypeMismatch(expected: "Well formatted date string", actual: end))
        }
        
        agendaItem.end = endDate
        
        agendaItem.urlString = json["url"].stringValue

        return .Success(agendaItem)
    }
}
