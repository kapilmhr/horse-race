////
////  NetworkSession.swift
////  horse_racing
////
////  Created by Kapil Maharjan on 15/12/2024.
////
//
//import SwiftUI
//
//
//protocol NetworkSession {
//    func data(for request: URLRequest) async throws -> (Data, URLResponse)
//}
//
//extension URLSession: NetworkSession {
//    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
//        return try await self.data(for: request) // Calls URLSession's own implementation
//    }
//}
