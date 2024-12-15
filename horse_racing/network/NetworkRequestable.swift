////
////  NetworkRequestable.swift
////  horse_racing
////
////  Created by Kapil Maharjan on 15/12/2024.
////
//
//import Foundation
//
//protocol NetworkRequestable {
//    func buildRequest(from endpoint: Endpoint) throws -> URLRequest
//}
//
//final class NetworkRequestBuilder: NetworkRequestable {
//    
//    func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
//        guard let url = endpoint.url else {
//            throw NetworkManager.NetworkError.invalidUrl
//        }
//        
//        var request = URLRequest(url: url)
//        
//        switch endpoint.methodType {
//        case .GET:
//            request.httpMethod = "GET"
//        case .POST:
//            request.httpMethod = "POST"
//        case .PUT:
//            request.httpMethod = "PUT"
//        case .DELETE:
//            request.httpMethod = "DELETE"
//        }
//        
//        return request
//    }
//}
