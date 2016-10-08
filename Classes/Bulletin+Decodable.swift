//
//  Bulletin+Decodable.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 19-05-16.
//
//

import Foundation
import JsonApiClient

extension Bulletin : Decodable {
    public typealias DecodedType = Bulletin
    
    public static func decode(_ json: JSON) -> Decoded<Bulletin> {
        let bulletin = Bulletin()
        bulletin.title = json["title"].stringValue
        
        guard let publishedAtString = json["publishedAt"].string else {
            return Decoded.failure(DecodeError.missingKey("publishedAt"))
        }
        guard let publishedAt = jsonDateFormatter.date(from:publishedAtString) else {
            return Decoded.failure(DecodeError.typeMismatch(expected: "Well formatted date string", actual: publishedAtString))
        }

        bulletin.publishedAt = publishedAt
        bulletin.body = json["body"].stringValue
        bulletin.urlString = json["url"].stringValue
        
        return .success(bulletin)
    }
}
