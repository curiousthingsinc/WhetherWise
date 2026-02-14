//
//  HourlyWeatherViewModel.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/14/26.
//

import Foundation
import Combine

@MainActor
public final class HourlyWeatherViewModel: ObservableObject {
  private let weatherService: WeatherDataService
  
  @Published public var hourlyData: [HourlyForecast] = []
  @Published var errorMessage: String?
  @Published var isLoading: Bool = false
  
  public init(weatherService: WeatherDataService) {
    self.weatherService = weatherService
  }
  
  public func loadNext24Hours() {
    isLoading = true
    errorMessage = nil
    
    Task { [weak self] in
      guard let self else { return }
      
      let now = Date()
      let end = Calendar.current.date(byAdding: .hour, value: 24, to: now) ?? now
      
      do {
        // This is now safe because HourlyWeatherPoint is Sendable
        let data = try await self.weatherService.hourlyWeather(from: now, to: end)
        self.hourlyData = data
      } catch {
        self.errorMessage = error.localizedDescription
      }
      self.isLoading = false
    }
  }
}
