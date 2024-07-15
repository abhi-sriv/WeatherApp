//
//  NetworkConstants.swift
//  SwiftUIIntergrationProject
//
//  Created by Abhishek Dilip Srivastava on 14/07/24.
//

import Foundation

enum NetworkErrorMessage: String, Error {
    case invalidURL = "The URL provided is invalid. Please verify the server endpoints."
    case invalidData = "The data format is unsupported. Please ensure the data format is correct."
    case invalidResponse = "Received an invalid response from the server. Please try again."
    case unknownError = "An unexpected error occurred. Please try again."
    case noInternet = "No internet connection detected. Please check your connection and try again."
    case timeout = "The request timed out. Please check your connection and try again."
    case unauthorized = "Unauthorized access. Please check your credentials and try again."
    case forbidden = "You do not have permission to access this resource. Please contact support."
    case notFound = "The requested resource could not be found. Please verify the URL and try again."
    case serverError = "The server encountered an error. Please try again later."
    case serviceUnavailable = "The service is currently unavailable. Please try again later."
}
