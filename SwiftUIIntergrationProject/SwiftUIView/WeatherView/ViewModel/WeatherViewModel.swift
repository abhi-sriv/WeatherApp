//
//  WeatherViewModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Abhishek Dilip Srivastava on 14/07/24.
//

import Foundation
import SwiftUI
import MapKit

/**
 ViewModel responsible for weather data presentation and interaction
 */
protocol WeatherViewModelable: ObservableObject {
    var addressList: [String] { get set }
    
    // View Presentation Models
    var weatherDisplayData: CurrentWeatherDisplayData? { get }
    var forecast: ForecastDisplayData? { get }
    
    var errorMessage: String? {get set}
    
    /**
     Get the current weather and forecast for a given address.
     - Parameter address: The string representing the address for which to retrieve weather data.
     - Note: This method uses asynchronous tasks to fetch the coordinates, current weather, and forecast data.
     */
    func getCurrentWeatherAndForecast(address: String)
    
    /**
     Get the weather forecast data for a given location.
     - Parameter location: The CLLocation object representing the location for which to fetch weather forecast data.
     - Note: This method uses an asynchronous task to retrieve the forecast data and updates the forecast property.
     */
    func getWeatherForecast(location: CLLocation)
    
    /**
     Get the current weather data for a given location.
     - Parameter location: The CLLocation object representing the location for which to fetch current weather data.
     - Note: This method uses an asynchronous task to retrieve the current weather data and updates the weatherDisplayData property.
     */
    func getCurrentWeather(location: CLLocation)
}

@Observable
final class WeatherViewModel: WeatherViewModelable {
    private let addressService: AddressService
    private let weatherService: WeatherServiceable
    
    var addressList: [String]
    var errorMessage: String?
    
    // View Presentation Models
    private(set) var weatherDisplayData: CurrentWeatherDisplayData?
    private(set) var forecast: ForecastDisplayData?
    
    init(addressList: [String] = Addresses,
         addressService: AddressService = AddressService.live,
         weatherService: WeatherServiceable = WeatherService.live) {
        self.addressList = addressList
        self.addressService = addressService
        self.weatherService = weatherService
    }
    
    func getCurrentWeatherAndForecast(address: String) {
        Task {
            do {
                if let location = try await self.addressService.asyncCoordinate(address) {
                    self.getWeatherForecast(location: location)
                    self.getCurrentWeather(location: location)
                } else {
                    self.errorMessage = "Error fetching co-ordinates for this location. Please try again."
                }
            } catch  {
                self.errorMessage = "Error fetching co-ordinates for this location. Please try again."
            }
        }
    }
    
    func getWeatherForecast(location: CLLocation) {
        Task {
            do {
                let _forcastDisplayData = try await self.weatherService.retrieveWeatherForecast(location: location)
                self.forecast = ForecastDisplayData(from: _forcastDisplayData)
            } catch (let error) {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getCurrentWeather(location: CLLocation) {
        Task {
            do {
                let _weatherDisplayData = try await self.weatherService.retrieveCurrentWeather(location: location)
                self.weatherDisplayData = CurrentWeatherDisplayData(from: _weatherDisplayData)
            } catch (let error) {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
