//
//  NetworkService.swift
//  SwiftUIIntergrationProject
//
//  Created by Abhishek Dilip Srivastava on 14/07/24.
//

import Foundation

/**
 A foundation class that can handles the network requests / responses across the app.
 */
protocol NetworkServicable {
    /**
     Fetches data from the specified URL using async/await.
     - Parameters:
     - url: The URL to fetch data from.
     - Returns: The fetched data.
     - Throws: ```NetworkError``` if the request fails.
     */
    func fetchData(from url: URL) async throws -> Data
}

class NetworkService: NetworkServicable {
    
    private let session: URLSessionProtocol
    
    /// initializer with session object that confirms to ```URLSessionProtocol```
    /// By default it initializes with ```URLSession.shared```
    /// - Parameter session:
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await session.data(from: url)
            
            // Ensure that the response is an HTTPURLResponse and the status code indicates success (200-299).
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }
            return data
        } catch {
            throw handleError(error)
        }
    }
    
    private func handleError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternetConnection
            case .badURL, .unsupportedURL:
                return .invalidURL
            case .badServerResponse, .cannotFindHost:
                return .invalidResponse
            default:
                return .custom(error)
            }
        } else if let nsError = error as NSError? {
            switch nsError.code {
            case NSURLErrorTimedOut:
                return .timeout
            case NSURLErrorUserAuthenticationRequired:
                return .unauthorized
            case NSURLErrorUserCancelledAuthentication:
                return .forbidden
            case NSURLErrorCannotFindHost, NSURLErrorBadServerResponse, 3:
                return .invalidResponse
            case 500...599:
                return .serverError
            case NSURLErrorResourceUnavailable:
                return .serviceUnavailable
            default:
                return .custom(error)
            }
        } else {
            if let internalError = error as? NetworkError {
                if internalError == .invalidResponse {
                    return .invalidResponse
                }
            }
            return .custom(error)
        }
    }
}
