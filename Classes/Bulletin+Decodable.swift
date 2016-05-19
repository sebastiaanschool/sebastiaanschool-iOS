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

extension Bulletin : Decodable {
    public typealias DecodedType = Bulletin
    
    public static func decode(json: JSON) -> Decoded<Bulletin> {
        return .Success(Bulletin())
    }
}
