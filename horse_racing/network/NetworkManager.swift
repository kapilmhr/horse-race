//
//  NetworkingManagerImpl.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 15/12/2024.
//


import Foundation

protocol NetworkManagerImpl {
    
    func request<T: Codable>(session: URLSession,_ endpoint: Endpoint,type: T.Type) async throws -> T
    
    func request(session: URLSession,
                 _ endpoint: Endpoint) async throws
}

final class NetworkManager: NetworkManagerImpl {
    
    static let shared = NetworkManager()
    
    private init() {}
    
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
    
    func request(session: URLSession = .shared,
                 _ endpoint: Endpoint) async throws {
        
        guard let url = endpoint.url else {
            throw NetworkError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)

        let (_, response) = try await session.data(for: request)

        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }
        
    }
}

extension NetworkManager {
    enum NetworkError: LocalizedError {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

extension NetworkManager.NetworkError: Equatable {
    
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

extension NetworkManager.NetworkError {
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL isn't valid"
        case .invalidStatusCode:
            return "Status code falls into the wrong range"
        case .invalidData:
            return "Response data is invalid"
        case .failedToDecode:
            return "Failed to decode"
        case .custom(let err):
            return "Something went wrong \(err.localizedDescription)"
        }
    }
}

private extension NetworkManager {
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
