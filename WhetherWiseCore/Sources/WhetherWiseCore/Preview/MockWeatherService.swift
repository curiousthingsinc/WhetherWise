//
//  MockWeatherService.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/14/26.
//

import Foundation

public struct MockWeatherService: WeatherDataService, @unchecked Sendable {
  public init() {}
  public func hourlyWeather(from start: Date, to end: Date) async throws -> [HourlyForecast] {
    return HourlyForecast.mockData
  }
}
