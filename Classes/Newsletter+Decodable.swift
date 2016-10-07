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
        return .success(newsletter)
    }
}
