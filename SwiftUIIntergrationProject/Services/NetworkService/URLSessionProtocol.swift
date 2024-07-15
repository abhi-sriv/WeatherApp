//
//  NetworkServiceProtocol.swift
//  SwiftUIIntergrationProject
//
//  Created by Abhishek Dilip Srivastava on 14/07/24.
//

import Foundation

// Protocol that wraps the URLSession to facilitate mocking while unit testing
protocol URLSessionProtocol {
    /// Start a data task with a URL using async/await.
    /// - parameter url: The URL to send a request to.
    /// - returns: A tuple containing the binary `Data` that was downloaded,
    ///   as well as a `URLResponse` representing the server's response.
    /// - throws: Any error encountered while performing the data task.
    func data(from url: URL) async throws -> (Data, URLResponse)
    
    /// Start a data task with a `URLRequest` using async/await.
    /// - parameter request: The `URLRequest` that the data task should perform.
    /// - returns: A tuple containing the binary `Data` that was downloaded,
    ///   as well as a `URLResponse` representing the server's response.
    /// - throws: Any error encountered while performing the data task.
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(for: URLRequest(url: url))
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        var dataTask: URLSessionDataTask?
        let onCancel = { dataTask?.cancel() }
        
        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { continuation in
                    dataTask = self.dataTask(with: request) { data, response, error in
                        guard let data = data, let response = response else {
                            let error = error ?? URLError(.badServerResponse)
                            return continuation.resume(throwing: error)
                        }
                        
                        continuation.resume(returning: (data, response))
                    }
                    
                    dataTask?.resume()
                }
            },
            onCancel: {
                onCancel()
            }
        )
    }
}
