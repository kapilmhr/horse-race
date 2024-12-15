//
//  NetworkingManagerImpl.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 15/12/2024.
//


import Foundation

// Protocol that defines the contract for any network manager implementation.
protocol NetworkManagerImpl {
    /// Asynchronous request method to fetch data from a specified `endpoint`.
    ///
    /// - Parameters:
    ///   - session: The `URLSession` instance used to perform the request. Defaults to `.shared`.
    ///   - endpoint: The `Endpoint` object that specifies the URL and the HTTP method for the request.
    ///   - type: The expected response model type, which should conform to `Codable`.
    ///
    /// - Returns: The decoded response object of type `T`.
    /// - Throws: A `NetworkError` if the request fails (e.g., invalid URL, failed to decode).
    
    func request<T: Codable>(session: URLSession,_ endpoint: Endpoint,type: T.Type) async throws -> T
    
}

/// A concrete implementation of the `NetworkManagerImpl` protocol.
/// This is a singleton class used to make network requests in the application.

final class NetworkManager: NetworkManagerImpl {
    
    // Singleton instance
    static let shared = NetworkManager()
    
    private init() {}
    
    
    /// Sends a network request and decodes the response into a model of type `T`.
    ///
    /// - Parameters:
    ///   - session: `URLSession` instance (defaults to `.shared`).
    ///   - endpoint: The endpoint containing URL and HTTP method.
    ///   - type: The type of the model expected in the response.
    /// - Returns: Decoded model of type `T`.
    /// - Throws: `NetworkError` if any error occurs.
    
    func request<T: Codable>(session: URLSession = .shared,
                             _ endpoint: Endpoint,
                             type: T.Type) async throws -> T {
        
        guard let url = endpoint.url else {
            throw NetworkError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        let res = try decoder.decode(T.self, from: data)
        
        return res
    }
}

extension NetworkManager.NetworkError: Equatable {
    
    // Equatable implementation for comparing `NetworkError` instances.
    
    static func == (lhs: NetworkManager.NetworkError, rhs: NetworkManager.NetworkError) -> Bool {
        switch(lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
        case (.custom(let lhsType), .custom(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
            return lhsType == rhsType
        case (.invalidData, .invalidData):
            return true
        case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}


private extension NetworkManager {
    
    // Builds a URLRequest from the given URL and HTTP method.
    func buildRequest(from url: URL,
                      methodType: Endpoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST:
            request.httpMethod = "POST"
        case .PUT:
            request.httpMethod = "PUT"
        case .DELETE:
            request.httpMethod = "DELETE"
        }
        return request
    }
}
