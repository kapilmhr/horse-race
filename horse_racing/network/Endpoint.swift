//
//  Endpoint.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 15/12/2024.
//
import Foundation

enum Endpoint{
    case racing
}

extension Endpoint{
    enum MethodType {
        case GET
        case POST
        case PUT
        case DELETE
    }
}

extension Endpoint {
    
    var host: String { "api.neds.com.au" }
    
    var path: String {
        switch self {
        case .racing:
            return "/rest/v1/racing/"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .racing:
            return .GET
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .racing:
            return ["method":"nextraces", "count":"10"]
        }
    }
}
extension Endpoint {
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        
        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        //        #if DEBUG
        //        requestQueryItems.append(URLQueryItem(name: "method", value: "nextraces"))
        //        requestQueryItems.append(URLQueryItem(name: "count", value: "10"))
        //        #endif
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}
