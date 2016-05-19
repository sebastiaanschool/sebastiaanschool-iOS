//
//  SebastiaanApiClient.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-05-16.
//
//

import Foundation
import SwiftyJSON
import JsonApiClient

public var jsonDateFormatter: NSDateFormatter = {
    let RFC3339DateFormatter = NSDateFormatter()
    RFC3339DateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    RFC3339DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    return RFC3339DateFormatter
}()

public class SebastiaanApiClient: ApiClient {
    static let serverURL = "https://backend-sebastiaanschool.rhcloud.com/"
    static let baseURL = serverURL + "api/"
    
    public static var sharedApiClient: SebastiaanApiClient = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return SebastiaanApiClient(configuration: config)
    }()
    
    enum Endpoints {
        case AgendaItems
        case Bulletins
        case ContactItems
        case Newsletters
        case Timeline
        
        var url: NSURL {
            let path: String
            switch self {
            case .AgendaItems:
                path = "agendaItems/"
            case .Bulletins:
                path = "bulletins/"
            case .ContactItems:
                path = "contactItems/"
            case .Newsletters:
                path = "newsletters/"
            case .Timeline:
                path = "timeline/"
            }
            return NSURL(string: SebastiaanApiClient.baseURL + path)!
        }
    }
    
    public func fetchAgendaItems(completion: ApiClientResult<[AgendaItem]> -> Void) {
        let url = Endpoints.AgendaItems.url
        let request = NSURLRequest(URL:url)
        
        fetchResources(request) { (result: ApiClientResult<[AgendaItem]>) in
            completion(result)
        }
    }
    
    public func fetchBulletins(completion: ApiClientResult<[Bulletin]> -> Void) {
        let url = Endpoints.Bulletins.url
        let request = NSURLRequest(URL: url)
        
        fetchResources(request) { (result: ApiClientResult<[Bulletin]>) in
            completion(result)
        }
    }
}
