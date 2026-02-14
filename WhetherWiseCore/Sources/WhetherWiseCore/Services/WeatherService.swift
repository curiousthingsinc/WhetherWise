//
//  WeatherService.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/14/26.
//

import Foundation
import CoreLocation
import WeatherKit

// MARK: - Error Type

/// Errors that can occur while fetching weather data
public enum WeatherServiceError: Error, LocalizedError {
  case locationUnavailable
  case locationNotAuthorized
  case invalidDateRange
  case weatherServiceUnavailable
  case underlying(Error)
  
  public var errorDescription: String? {
    switch self {
    case .locationUnavailable:
      return "The current location could not be determined."
    case .locationNotAuthorized:
      return "Location access is not authorized. Please enable location services in Settings."
    case .invalidDateRange:
      return "The requested date range is invalid."
    case .weatherServiceUnavailable:
      return "Weather data is currently unavailable."
    case .underlying(let error):
      return error.localizedDescription
    }
  }
}

// MARK: - Protocols

/// Abstraction for something that can provide the user's current location
public protocol LocationProviding {
  func currentLocation() async throws -> CLLocation
}

/// Abstraction for a service that can fetch hourly weather data
public protocol WeatherDataService: Sendable {
  func hourlyWeather(from startDate: Date, to endDate: Date) async throws -> [HourlyForecast]
}

// MARK: - Location Provider

/// Simple Core Location based provider for the current location.
public final class LocationProvider: NSObject, LocationProviding {
  private let locationManager = CLLocationManager()
  private var continuation: CheckedContinuation<CLLocation, Error>?
  
  public override init() {
    super.init()
    locationManager.delegate = self
  }
  
  public func currentLocation() async throws -> CLLocation {
    let status = locationManager.authorizationStatus
    switch status {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted, .denied:
      throw WeatherServiceError.locationNotAuthorized
    case .authorizedAlways, .authorizedWhenInUse:
      break
    @unknown default:
      break
    }
    
    if let location = locationManager.location {
      return location
    }
    
    return try await withCheckedThrowingContinuation { continuation in
      self.continuation = continuation
      locationManager.requestLocation()
    }
  }
}

extension LocationProvider: CLLocationManagerDelegate {
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    continuation?.resume(returning: location)
    continuation = nil
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    continuation?.resume(throwing: error)
    continuation = nil
  }
}

// MARK: - WeatherKit-backed implementation

/// Concrete implementation of `WeatherDataService` that uses WeatherKit
public final class WeatherKitDataService: WeatherDataService, @unchecked Sendable {
  
  private let weatherService: WeatherService
  private let locationProvider: LocationProviding
  
  public init(weatherService: WeatherService = WeatherService.shared,
              locationProvider: LocationProviding = LocationProvider()) {
    self.weatherService = weatherService
    self.locationProvider = locationProvider
  }
  
  public func hourlyWeather(from startDate: Date, to endDate: Date) async throws -> [HourlyForecast] {
    guard startDate < endDate else {
      throw WeatherServiceError.invalidDateRange
    }
    
    let location: CLLocation
    do {
      location = try await locationProvider.currentLocation()
    } catch {
      if let error = error as? WeatherServiceError {
        throw error
      } else {
        throw WeatherServiceError.underlying(error)
      }
    }
    
    do {
      let forecast = try await weatherService.weather(for: location, including: .hourly)
      
      return forecast.forecast.filter { $0.date >= startDate && $0.date < endDate }.map { hour in
        HourlyForecast(
          date: hour.date,
          temperature: hour.temperature.value,
          apparentTemperature: hour.apparentTemperature.value,
          dewPoint: hour.dewPoint.value,
          precipitationChance: hour.precipitationChance,
          precipitationAmount: hour.precipitationAmount.value,
          precipitationType: hour.precipitation.description,
          windSpeed: hour.wind.speed.value,
          windGust: hour.wind.gust?.value ?? 0.0,
          windDirection: hour.wind.direction.value,
          humidity: hour.humidity,
          pressure: hour.pressure.value,
          cloudCover: hour.cloudCover,
          visibility: hour.visibility.value,
          condition: hour.condition.description,
          uvIndex: hour.uvIndex.value,
          isDaytime: hour.isDaylight
        )
      }
    } catch {
      throw WeatherServiceError.underlying(error)
    }
  }
}
