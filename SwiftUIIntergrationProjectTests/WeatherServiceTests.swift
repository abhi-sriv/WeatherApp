//
//  WeatherServiceTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Abhishek Dilip Srivastava on 15/07/24.
//

import XCTest
import CoreLocation
@testable import SwiftUIIntergrationProject

// Mock Network Service
class MockNetworkService: NetworkServicable {
    var shouldReturnError = false
    var error: NetworkError = .invalidURL
    var data: Data?
    
    func fetchData(from url: URL) async throws -> Data {
        if shouldReturnError {
            throw error
        }
        return data ?? Data()
    }
}

final class WeatherServiceTests: XCTestCase {
    var weatherService: WeatherService!
    var mockNetworkService: MockNetworkService!
    var sampleLocation: CLLocation!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        weatherService = WeatherService(networkService: mockNetworkService)
        sampleLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco coordinates
    }
    
    override func tearDown() {
        weatherService = nil
        mockNetworkService = nil
        sampleLocation = nil
        super.tearDown()
    }
    
    func testRetrieveCurrentWeather_Success() async {
        // Given
        let jsonData = """
        {
            "weather": [{"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}],
            "main": {"temp": 15.0, "feels_like": 14.0, "humidity": 72},
            "wind": {"speed": 3.5, "deg": 200},
            "dt": 1628416800,
            "id": 5391959,
            "name": "San Francisco"
        }
        """.data(using: .utf8)!
        mockNetworkService.data = jsonData
        
        // When
        do {
            let currentWeather = try await weatherService.retrieveCurrentWeather(location: sampleLocation)
            // Then
            XCTAssertEqual(currentWeather.name, "San Francisco")
            XCTAssertEqual(currentWeather.main.temp, 15.0)
            XCTAssertEqual(currentWeather.weather.first?.main.rawValue, "Clear")
        } catch {
            XCTFail("Expected successful weather data retrieval, but got error: \(error)")
        }
    }
    
    func testRetrieveCurrentWeather_NetworkError() async {
        // Given
        mockNetworkService.shouldReturnError = true
        mockNetworkService.error = .invalidURL
        
        // When
        do {
            _ = try await weatherService.retrieveCurrentWeather(location: sampleLocation)
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Expected NetworkError, but got: \(error)")
        }
    }
    
    func testRetrieveWeatherForecast_Success() async {
        // Given
        let jsonData = """
        {
            "cod": "200",
            "message": 0,
            "cnt": 40,
            "list": [{
                "dt": 1628416800,
                "main": {"temp": 15.0, "feels_like": 14.0, "humidity": 72},
                "weather": [{"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}],
                "wind": {"speed": 3.5, "deg": 200},
                "rain": {"3h": 0.0}
            }],
            "city": {"id": 5391959, "name": "San Francisco"}
        }
        """.data(using: .utf8)!
        mockNetworkService.data = jsonData
        
        // When
        do {
            let forecast = try await weatherService.retrieveWeatherForecast(location: sampleLocation)
            // Then
            XCTAssertEqual(forecast.city.name, "San Francisco")
            XCTAssertEqual(forecast.list.first?.temperatures.temp, 15.0)
            XCTAssertEqual(forecast.list.first?.weather.first?.main.rawValue, "Clear")
        } catch {
            XCTFail("Expected successful forecast data retrieval, but got error: \(error)")
        }
    }
    
    func testRetrieveWeatherForecast_NetworkError() async {
        // Given
        mockNetworkService.shouldReturnError = true
        mockNetworkService.error = .invalidData
        
        // When
        do {
            _ = try await weatherService.retrieveWeatherForecast(location: sampleLocation)
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, .invalidData)
        } catch {
            XCTFail("Expected NetworkError, but got: \(error)")
        }
    }
}
