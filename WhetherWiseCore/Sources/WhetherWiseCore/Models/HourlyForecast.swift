//
//  HourlyForecast.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/14/26.
//

import Foundation

import Foundation

public struct HourlyForecast: Sendable, Identifiable {
  public let id: Date
  public let date: Date
  
  // Explicit Properties
  public let temperature: Double
  public let apparentTemperature: Double
  public let dewPoint: Double
  public let precipitationChance: Double
  public let precipitationAmount: Double
  public let precipitationType: String
  public let windSpeed: Double
  public let windGust: Double
  public let windDirection: Double
  public let humidity: Double
  public let pressure: Double
  public let cloudCover: Double
  public let visibility: Double
  public let condition: String
  public let uvIndex: Int
  public let isDaytime: Bool
  
  public init(
    date: Date,
    temperature: Double,
    apparentTemperature: Double,
    dewPoint: Double,
    precipitationChance: Double,
    precipitationAmount: Double,
    precipitationType: String,
    windSpeed: Double,
    windGust: Double,
    windDirection: Double,
    humidity: Double,
    pressure: Double,
    cloudCover: Double,
    visibility: Double,
    condition: String,
    uvIndex: Int,
    isDaytime: Bool
  ) {
    self.id = date
    self.date = date
    self.temperature = temperature
    self.apparentTemperature = apparentTemperature
    self.dewPoint = dewPoint
    self.precipitationChance = precipitationChance
    self.precipitationAmount = precipitationAmount
    self.precipitationType = precipitationType
    self.windSpeed = windSpeed
    self.windGust = windGust
    self.windDirection = windDirection
    self.humidity = humidity
    self.pressure = pressure
    self.cloudCover = cloudCover
    self.visibility = visibility
    self.condition = condition
    self.uvIndex = uvIndex
    self.isDaytime = isDaytime
  }
}

public extension HourlyForecast {
  static let mockData: [HourlyForecast] = [
    // 1. Sunny Afternoon
    HourlyForecast(
      date: Date(),
      temperature: 72.5,
      apparentTemperature: 74.0,
      dewPoint: 55.0,
      precipitationChance: 0.05,
      precipitationAmount: 0.0,
      precipitationType: "none",
      windSpeed: 8.5,
      windGust: 12.0,
      windDirection: 180.0,
      humidity: 0.45,
      pressure: 1013.2,
      cloudCover: 0.10,
      visibility: 10.0,
      condition: "Clear",
      uvIndex: 6,
      isDaytime: true
    ),
    
    // 2. Clouding Over
    HourlyForecast(
      date: Date().addingTimeInterval(3600),
      temperature: 68.0,
      apparentTemperature: 68.0,
      dewPoint: 58.0,
      precipitationChance: 0.30,
      precipitationAmount: 0.0,
      precipitationType: "none",
      windSpeed: 10.0,
      windGust: 18.0,
      windDirection: 195.0,
      humidity: 0.55,
      pressure: 1011.5,
      cloudCover: 0.65,
      visibility: 8.0,
      condition: "Mostly Cloudy",
      uvIndex: 2,
      isDaytime: true
    ),
    
    // 3. Light Rain Starting
    HourlyForecast(
      date: Date().addingTimeInterval(7200),
      temperature: 62.5,
      apparentTemperature: 61.0,
      dewPoint: 60.0,
      precipitationChance: 0.85,
      precipitationAmount: 0.05,
      precipitationType: "rain",
      windSpeed: 14.0,
      windGust: 25.0,
      windDirection: 210.0,
      humidity: 0.88,
      pressure: 1008.2,
      cloudCover: 1.0,
      visibility: 4.5,
      condition: "Rain",
      uvIndex: 0,
      isDaytime: false
    ),
    
    // 4. Nighttime Storm
    HourlyForecast(
      date: Date().addingTimeInterval(10800),
      temperature: 59.0,
      apparentTemperature: 55.0,
      dewPoint: 58.5,
      precipitationChance: 0.95,
      precipitationAmount: 0.25,
      precipitationType: "rain",
      windSpeed: 18.0,
      windGust: 35.0,
      windDirection: 230.0,
      humidity: 0.92,
      pressure: 1005.4,
      cloudCover: 1.0,
      visibility: 2.0,
      condition: "Heavy Rain",
      uvIndex: 0,
      isDaytime: false
    )
  ]
}
