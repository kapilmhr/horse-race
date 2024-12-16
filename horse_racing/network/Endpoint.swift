//
//  Endpoint.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 15/12/2024.
//
import Foundation

enum Endpoint {
    case racing(method: String, count: Int)
}

extension Endpoint {
    enum MethodType: Equatable {
        case GET
        case POST
        case PUT
        case DELETE
    }
}

extension Endpoint {

    var host: String { ApiConstant.baseUrl }

    var path: String {
        switch self {
        case .racing:
            return ApiConstant.race
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
        case .racing(let method, let count):
            return ["method": "\(method)", "count": "\(count)"]
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
