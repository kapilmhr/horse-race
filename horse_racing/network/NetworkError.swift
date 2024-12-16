//
//  NetworkError.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 15/12/2024.
//

import Foundation

extension NetworkManager {

    enum NetworkError: LocalizedError {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)

        var errorDescription: String? {
            switch self {
            case .invalidUrl:
                return "The URL is invalid."
            case .invalidStatusCode(let statusCode):
                return "Received invalid status code: \(statusCode)."
            case .invalidData:
                return "The data received was invalid."
            case .failedToDecode:
                return "Failed to decode the response data."
            case .custom(let error):
                return "Custom error occurred: \(error.localizedDescription)"
            }
        }
    }
}
