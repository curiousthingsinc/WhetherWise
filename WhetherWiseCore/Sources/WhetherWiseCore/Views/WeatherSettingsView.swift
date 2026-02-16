//
//  SwiftUIView.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/16/26.
//

import SwiftUI

struct WeatherSettingsView: View {
  @State private var refresh = false
  
  var body: some View {
    Section("Weather Units") {
      Picker("Temperature", selection: binding(for: \.temperatureUnit)) {
        Text("Celsius (°C)").tag(TemperatureUnitPreference.celsius)
        Text("Fahrenheit (°F)").tag(TemperatureUnitPreference.fahrenheit)
      }
      
      Picker("Pressure", selection: binding(for: \.pressureUnit)) {
        Text("Hectopascals (hPa)").tag(PressureUnitPreference.hectopascals)
        Text("Inches of Mercury (inHg)").tag(PressureUnitPreference.inchesOfMercury)
        Text("Millibars (mb)").tag(PressureUnitPreference.millibars)
      }
      
      Picker("Distance", selection: binding(for: \.distanceUnit)) {
        Text("Kilometers (km)").tag(DistanceUnitPreference.kilometers)
        Text("Miles (mi)").tag(DistanceUnitPreference.miles)
      }
      
      Picker("Speed", selection: binding(for: \.speedUnit)) {
        Text("m/s").tag(SpeedUnitPreference.metersPerSecond)
        Text("km/h").tag(SpeedUnitPreference.kilometersPerHour)
        Text("mph").tag(SpeedUnitPreference.milesPerHour)
      }
      
      Picker("Precipitation", selection: binding(for: \.lengthUnit)) {
        Text("Millimeters (mm)").tag(LengthUnitPreference.millimeters)
        Text("Inches (in)").tag(LengthUnitPreference.inches)
      }
    }
    .id(refresh)
  }
  
  private func binding<T>(for keyPath: ReferenceWritableKeyPath<WeatherSettings.Type, T>) -> Binding<T> {
    Binding(
      get: { WeatherSettings.self[keyPath: keyPath] },
      set: {
        WeatherSettings.self[keyPath: keyPath] = $0
        refresh.toggle()
      }
    )
  }
}
