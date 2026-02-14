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
