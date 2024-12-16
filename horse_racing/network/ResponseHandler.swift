////
////  ResponseHandler.swift
////  horse_racing
////
////  Created by Kapil Maharjan on 15/12/2024.
////
//
//import Foundation
//
//protocol ResponseHandler {
//    func handleResponse<T: Codable>(data: Data, response: URLResponse) throws -> T
//}
//
//final class JSONResponseHandler: ResponseHandler {
//    
//    func handleResponse<T: Codable>(data: Data, response: URLResponse) throws -> T {
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200...299).contains(httpResponse.statusCode) else {
//            throw NetworkManager.NetworkError.invalidStatusCode(statusCode: (response as! HTTPURLResponse).statusCode)
//        }
//        
//        let decoder = JSONDecoder()
//        do {
//            return try decoder.decode(T.self, from: data)
//        } catch {
//            throw NetworkManager.NetworkError.failedToDecode(error: error)
//        }
//    }
//}
