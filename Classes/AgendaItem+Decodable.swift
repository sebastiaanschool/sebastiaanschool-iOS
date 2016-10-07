//
//  AgendaItems+Decodable.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-05-16.
//
//

import Foundation
import JsonApiClient

extension AgendaItem : Decodable {
    public typealias DecodedType = AgendaItem
    
    public static func decode(_ json: JSON) -> Decoded<AgendaItem> {
        let agendaItem = AgendaItem()
        agendaItem.title = json["title"].stringValue
        if let dateString = json["start"].string {
            agendaItem.start = jsonDateFormatter.date(from:dateString)
        }

        guard let start = json["start"].string else {
            return Decoded.failure(DecodeError.missingKey("start"))
        }
        guard let startDate = jsonDateFormatter.date(from:start) else {
            return Decoded.failure(DecodeError.typeMismatch(expected: "Well formatted date string", actual: start))
        }
        
        agendaItem.start = startDate

        guard let end = json["end"].string else {
            return Decoded.failure(DecodeError.missingKey("end"))
        }
        guard let endDate = jsonDateFormatter.date(from:end) else {
            return Decoded.failure(DecodeError.typeMismatch(expected: "Well formatted date string", actual: end))
        }
        
        agendaItem.end = endDate
        
        agendaItem.urlString = json["url"].stringValue

        return .success(agendaItem)
    }
}
