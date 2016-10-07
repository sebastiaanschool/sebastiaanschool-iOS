//
//  SebastiaanApiClient.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-05-16.
//
//

import Foundation
import JsonApiClient

public var jsonDateFormatter: DateFormatter = {
    let RFC3339DateFormatter = DateFormatter()
    RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
    RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    return RFC3339DateFormatter
}()

open class SebastiaanApiClient: ApiClient {
    static let serverURL = "https://backend-sebastiaanschool.rhcloud.com/"
    static let baseURL = serverURL + "api/"
    
    open static var sharedApiClient: SebastiaanApiClient = {
        let config = URLSessionConfiguration.default
        return SebastiaanApiClient(configuration: config)
    }()
    
    enum Endpoints {
        case agendaItems
        case bulletins
        case contactItems
        case newsletters
        case timeline
        
        var url: URL {
            let path: String
            switch self {
            case .agendaItems:
                path = "agendaItems/?all"
            case .bulletins:
                path = "bulletins/"
            case .contactItems:
                path = "contactItems/"
            case .newsletters:
                path = "newsletters/"
            case .timeline:
                path = "timeline/"
            }
            return URL(string: SebastiaanApiClient.baseURL + path)!
        }
    }
    
    open func fetchAgendaItems(_ completion: @escaping (ApiClientResult<[AgendaItem]>) -> Void) {
        let url = Endpoints.agendaItems.url
        let request = URLRequest(url:url)
        
        fetchResources(request) { (result: ApiClientResult<[AgendaItem]>) in
            completion(result)
        }
    }
    
    open func fetchBulletins(_ completion: @escaping (ApiClientResult<[Bulletin]>) -> Void) {
        let url = Endpoints.bulletins.url
        let request = URLRequest(url: url)
        
        fetchResources(request) { (result: ApiClientResult<[Bulletin]>) in
            completion(result)
        }
    }
    
    open func fetchContactItems(_ completion: @escaping (ApiClientResult<[ContactItem]>) -> Void) {
        let url = Endpoints.contactItems.url
        let request = URLRequest(url: url)
        
        fetchResources(request) { (result: ApiClientResult<[ContactItem]>) in
            completion(result)
        }
    }
}
