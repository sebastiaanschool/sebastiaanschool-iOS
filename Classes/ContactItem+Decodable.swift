//
//  Bulletin+Decodable.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 19-05-16.
//
//

import Foundation
import SwiftyJSON
import JsonApiClient

extension ContactItem : Decodable {
    public typealias DecodedType = ContactItem
    
    public static func decode(json: JSON) -> Decoded<ContactItem> {
        let contactItem = ContactItem()
        return .Success(contactItem)
    }
}
