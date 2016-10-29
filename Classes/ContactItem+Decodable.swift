//
//  Bulletin+Decodable.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 19-05-16.
//
//

import Foundation
import JsonApiClient
import SwiftyJSON

extension ContactItem : Decodable {
    public typealias DecodedType = ContactItem
    
    public static func decode(_ json: JSON) -> Decoded<ContactItem> {
        let contactItem = ContactItem()
        contactItem.displayName = json["displayName"].stringValue
        contactItem.email = json["email"].string
        contactItem.order = json["order"].intValue
        contactItem.detailText = json["detailText"].stringValue
        contactItem.urlString = json["url"].stringValue
        return .success(contactItem)
    }
}
