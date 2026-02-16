//
//  UserSettings.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/16/26.
//

import Foundation

public enum TemperatureUnitPreference: String, Codable {
  case celsius
  case fahrenheit
  
  var unit: UnitTemperature {
    switch self {
    case .celsius: return .celsius
    case .fahrenheit: return .fahrenheit
    }
  }
}

public enum SpeedUnitPreference: String, Codable {
  case metersPerSecond
  case kilometersPerHour
  case milesPerHour
  
  var unit: UnitSpeed {
    switch self {
    case .metersPerSecond: return .metersPerSecond
    case .kilometersPerHour: return .kilometersPerHour
    case .milesPerHour: return .milesPerHour
    }
  }
}

public enum LengthUnitPreference: String, Codable {
  case millimeters
  case inches
  
  var unit: UnitLength {
    switch self {
    case .millimeters: return .millimeters
    case .inches: return .inches
    }
  }
}

public enum DistanceUnitPreference: String, Codable {
  case kilometers
  case miles
  
  var unit: UnitLength {
    switch self {
    case .kilometers: return .kilometers
    case .miles: return .miles
    }
  }
}

public enum PressureUnitPreference: String, Codable {
  case hectopascals
  case inchesOfMercury
  case millibars
  
  var unit: UnitPressure {
    switch self {
    case .hectopascals: return .hectopascals
    case .inchesOfMercury: return .inchesOfMercury
    case .millibars: return .millibars
    }
  }
}

extension Measurement {
  func converted(to preference: TemperatureUnitPreference) -> Measurement<UnitTemperature> where UnitType == UnitTemperature {
    converted(to: preference.unit)
  }
  
  func converted(to preference: SpeedUnitPreference) -> Measurement<UnitSpeed> where UnitType == UnitSpeed {
    converted(to: preference.unit)
  }
  
  func converted(to preference: PressureUnitPreference) -> Measurement<UnitPressure> where UnitType == UnitPressure {
    converted(to: preference.unit)
  }
  
  func converted(to preference: LengthUnitPreference) -> Measurement<UnitLength> where UnitType == UnitLength {
    converted(to: preference.unit)
  }
  
  func converted(to preference: DistanceUnitPreference) -> Measurement<UnitLength> where UnitType == UnitLength {
    converted(to: preference.unit)
  }
}

class WeatherSettings {
  nonisolated(unsafe) static let store = NSUbiquitousKeyValueStore.default
  
  nonisolated(unsafe) static var temperatureUnit: TemperatureUnitPreference {
    get {
      print("📖 Reading temperatureUnit")
      store.synchronize()
      
      if let data = store.data(forKey: "temperatureUnit") {
        print("✅ Found data for temperatureUnit")
        if let decoded = try? JSONDecoder().decode(TemperatureUnitPreference.self, from: data) {
          print("✅ Decoded: \(decoded)")
          return decoded
        } else {
          print("❌ Failed to decode")
        }
      } else {
        print("❌ No data found")
      }
      
      print("➡️ Returning default: fahrenheit")
      return .fahrenheit
    }
    set {
      print("💾 Writing temperatureUnit: \(newValue)")
      if let encoded = try? JSONEncoder().encode(newValue) {
        store.set(encoded, forKey: "temperatureUnit")
        let success = store.synchronize()
        print("💾 Synchronize result: \(success)")
      } else {
        print("❌ Failed to encode")
      }
    }
  }
  
  nonisolated(unsafe) static var speedUnit: SpeedUnitPreference {
    get {
      store.synchronize()
      guard let data = store.data(forKey: "speedUnit"),
            let decoded = try? JSONDecoder().decode(SpeedUnitPreference.self, from: data) else {
        return .milesPerHour
      }
      return decoded
    }
    set {
      if let encoded = try? JSONEncoder().encode(newValue) {
        store.set(encoded, forKey: "speedUnit")
        store.synchronize()
      }
    }
  }
  
  nonisolated(unsafe) static var lengthUnit: LengthUnitPreference {
    get {
      store.synchronize()
      guard let data = store.data(forKey: "lengthUnit"),
            let decoded = try? JSONDecoder().decode(LengthUnitPreference.self, from: data) else {
        return .inches
      }
      return decoded
    }
    set {
      if let encoded = try? JSONEncoder().encode(newValue) {
        store.set(encoded, forKey: "lengthUnit")
        store.synchronize()
      }
    }
  }
  
  nonisolated(unsafe) static var distanceUnit: DistanceUnitPreference {
    get {
      store.synchronize()
      guard let data = store.data(forKey: "distanceUnit"),
            let decoded = try? JSONDecoder().decode(DistanceUnitPreference.self, from: data) else {
        return .miles
      }
      return decoded
    }
    set {
      if let encoded = try? JSONEncoder().encode(newValue) {
        store.set(encoded, forKey: "distanceUnit")
        store.synchronize()
      }
    }
  }
  
  nonisolated(unsafe) static var pressureUnit: PressureUnitPreference {
    get {
      store.synchronize()
      guard let data = store.data(forKey: "pressureUnit"),
            let decoded = try? JSONDecoder().decode(PressureUnitPreference.self, from: data) else {
        return .inchesOfMercury
      }
      return decoded
    }
    set {
      if let encoded = try? JSONEncoder().encode(newValue) {
        store.set(encoded, forKey: "pressureUnit")
        store.synchronize()
      }
    }
  }
}

