//
//  ViewState.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import Foundation

public enum ViewState<T: Decodable>: Equatable {
    
    case ideal
    case loading(placeholder: T?) // TODO: change placeholder: T?
    case success(response: T)
    case empty
    case error(error: Error)
    
    public var errorValue: Error? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
    
    public var successValue: T? {
        if case .success(let response) = self {
            return response
        }
        return nil
    }
    
    public static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.ideal, .ideal):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.empty, .empty):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }

}
