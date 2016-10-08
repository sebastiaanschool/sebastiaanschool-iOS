//
//  Bulletin+Decodable.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 19-05-16.
//
//

import Foundation
import JsonApiClient

extension Newsletter : Decodable {
    public typealias DecodedType = Newsletter
    
    public static func decode(_ json: JSON) -> Decoded<Newsletter> {
        let newsletter = Newsletter()
        newsletter.title = json["title"].stringValue
        newsletter.documentUrlString = json["documentUrl"].stringValue

        guard let publishedAtString = json["publishedAt"].string else {
            return Decoded.failure(DecodeError.missingKey("publishedAt"))
        }
        guard let publishedAt = jsonDateFormatter.date(from:publishedAtString) else {
            return Decoded.failure(DecodeError.typeMismatch(expected: "Well formatted date string", actual: publishedAtString))
        }

        newsletter.publishedAt = publishedAt
        newsletter.urlString = json["url"].stringValue
        return .success(newsletter)
    }
}
