//
//  NetworkServicesTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Abhishek Dilip Srivastava on 15/07/24.
//

import XCTest

import XCTest
@testable import SwiftUIIntergrationProject

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(), response ?? URLResponse())
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await data(from: request.url!)
    }
}

class NetworkServiceTests: XCTestCase {

    var mockSession: MockURLSession!
    var networkService: NetworkService!
    let testURL = URL(string: "https://example.com")!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        networkService = nil
        super.tearDown()
    }

    func testFetchData_Success() async throws {
        // Arrange
        let expectedData = "Success".data(using: .utf8)!
        let response = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.data = expectedData
        mockSession.response = response

        // Act
        let data = try await networkService.fetchData(from: testURL)

        // Assert
        XCTAssertEqual(data, expectedData, "Fetched data should match expected data.")
    }

    func testFetchData_InvalidResponse() async {
        // Arrange
        let response = HTTPURLResponse(url: testURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        mockSession.response = response

        do {
            // Act
            _ = try await networkService.fetchData(from: testURL)
            XCTFail("Expected to throw an error but did not.")
        } catch {
            // Assert
            XCTAssertEqual((error as? NetworkError)?.message, NetworkError.invalidResponse.message, "Expected invalidResponse error.")
        }
    }

    func testFetchData_NoInternetConnection() async {
        // Arrange
        mockSession.error = URLError(.notConnectedToInternet)

        do {
            // Act
            _ = try await networkService.fetchData(from: testURL)
            XCTFail("Expected to throw an error but did not.")
        } catch {
            // Assert
            XCTAssertEqual(error as? NetworkError, NetworkError.noInternetConnection, "Expected noInternetConnection error.")
        }
    }

    func testFetchData_Timeout() async {
        // Arrange
        mockSession.error = URLError(.timedOut)

        do {
            // Act
            _ = try await networkService.fetchData(from: testURL)
            XCTFail("Expected to throw an error but did not.")
        } catch {
            // Assert
            XCTAssertEqual(error as? NetworkError, NetworkError.custom(mockSession.error), "Expected custom timeout error.")
        }
    }

    func testFetchData_InvalidURL() async {
        // Arrange
        mockSession.error = URLError(.badURL)

        do {
            // Act
            _ = try await networkService.fetchData(from: testURL)
            XCTFail("Expected to throw an error but did not.")
        } catch {
            // Assert
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL, "Expected invalidURL error.")
        }
    }
}
