import Foundation
import MapKit

//
///
/**
 TODO: Fill in this to retrieve current weather, and 5 day forecast
 * Use func currentWeatherURL(location: CLLocation) -> URL? to get the CurrentWeatherJSONData
 * Use func forecastURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> URL? to get the ForecastJSONData
 
 Once you have both the JSON Data, you can map:
 * CurrentWeatherJSONData -> CurrentWeatherDisplayData
 * ForecastJSONData ->ForecastDisplayData
 Both of these DisplayData structs contains the text you can bind/map to labels and we have included convience init that takes the JSON data so you can easily map them
 */

protocol WeatherServiceable {
    /**
     Retrieves the current weather data for a given location.
     - Parameter location: The CLLocation object representing the location.
     - Returns: The current weather data (`CurrentWeatherJSONData`).
     - Throws: A `NetworkError` in case of failure.
     */
    func retrieveCurrentWeather(location: CLLocation) async throws -> CurrentWeatherJSONData
    
    /**
     Retrieves the weather forecast data for a given location.
     - Parameter location: The CLLocation object representing the location.
     - Returns: The weather forecast data (`ForecastJSONData`).
     - Throws: A `NetworkError` in case of failure.
     */
    func retrieveWeatherForecast(location: CLLocation) async throws -> ForecastJSONData
}

struct WeatherService: WeatherServiceable {
    
    static var live = WeatherService(networkService: NetworkService())
    private let networkService: NetworkServicable
    
    /**
     Initializes the WeatherService with a network manager.
     - Parameters:
     - networkService: An object conforming to `NetworkServiceProtocol` to handle network requests.
     */
    init(networkService: NetworkServicable) {
        self.networkService = networkService
    }
    
    func retrieveCurrentWeather(location: CLLocation) async throws -> CurrentWeatherJSONData {
        guard let url = currentWeatherURL(location: location) else {
            throw NetworkError.invalidURL
        }
        
        let jsonData = try await networkService.fetchData(from: url)
        do {
            let currentWeather = try JSONDecoder().decode(CurrentWeatherJSONData.self, from: jsonData)
            return currentWeather
        } catch {
            throw NetworkError.custom(error.localizedDescription as? Error)
        }
    }
    
    func retrieveWeatherForecast(location: CLLocation) async throws -> ForecastJSONData {
        guard let url = forecastURL(location: location) else {
            throw NetworkError.invalidURL
        }
        
        let data = try await networkService.fetchData(from: url)
        do {
            let forecast = try JSONDecoder().decode(ForecastJSONData.self, from: data)
            return forecast
        } catch {
            throw NetworkError.custom(error.localizedDescription as? Error)
        }
    }
}
