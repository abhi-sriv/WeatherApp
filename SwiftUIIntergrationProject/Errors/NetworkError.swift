//
//  NetworkError.swift
//  SwiftUIIntergrationProject
//
//  Created by Abhishek Dilip Srivastava on 14/07/24.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidData
    case invalidResponse
    case noInternetConnection
    case timeout
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case serviceUnavailable
    case custom(_ error: Error?)
    
    var message: String {
        switch self {
        case .invalidURL:
            return NetworkErrorMessage.invalidURL.rawValue
        case .invalidData:
            return NetworkErrorMessage.invalidData.rawValue
        case .invalidResponse:
            return NetworkErrorMessage.invalidResponse.rawValue
        case .noInternetConnection:
            return NetworkErrorMessage.noInternet.rawValue
        case .timeout:
            return NetworkErrorMessage.timeout.rawValue
        case .unauthorized:
            return NetworkErrorMessage.unauthorized.rawValue
        case .forbidden:
            return NetworkErrorMessage.forbidden.rawValue
        case .notFound:
            return NetworkErrorMessage.notFound.rawValue
        case .serverError:
            return NetworkErrorMessage.serverError.rawValue
        case .serviceUnavailable:
            return NetworkErrorMessage.serviceUnavailable.rawValue
        case .custom(_):
            return NetworkErrorMessage.unknownError.rawValue
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
            (.invalidData, .invalidData),
            (.invalidResponse, .invalidResponse),
            (.noInternetConnection, .noInternetConnection),
            (.timeout, .timeout),
            (.unauthorized, .unauthorized),
            (.forbidden, .forbidden),
            (.notFound, .notFound),
            (.serverError, .serverError),
            (.serviceUnavailable, .serviceUnavailable):
            return true
        case (.custom(let lhsError), .custom(let rhsError)):
            // Compare the errors if they are not nil
            if let lhsError = lhsError, let rhsError = rhsError {
                let result = (lhsError as NSError).domain == (rhsError as NSError).domain &&
                (lhsError as NSError).code == (rhsError as NSError).code
                return result
            }
            // If both errors are nil, they are considered equal
            return lhsError == nil && rhsError == nil
        default:
            return false
        }
    }
}
