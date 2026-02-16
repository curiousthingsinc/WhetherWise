//
//  SwiftUIView.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/16/26.
//

#if os(iOS)
import SwiftUI
import CoreLocation

struct WeatherSettingsView_iOS: View {
  @StateObject private var locationAuth = LocationAuthManager()
  @State private var showLocationSearch = false
  @Environment(\.openURL) private var openURL
  
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
    
    Section("Default Location") {
      if locationAuth.authorizationStatus == .authorizedWhenInUse || locationAuth.authorizationStatus == .authorizedAlways {
        Toggle("Use Current Location", isOn: binding(for: \.useCurrentLocation))
        
        if !WeatherSettings.useCurrentLocation {
          Button {
            showLocationSearch = true
          } label: {
            HStack {
              Text("Location")
              Spacer()
              if let savedLocation = WeatherSettings.defaultLocation {
                Text(savedLocation.name)
                  .foregroundStyle(.secondary)
              } else {
                Text("Not Set")
                  .foregroundStyle(.secondary)
              }
            }
          }
        }
      } else {
        Button {
          showLocationSearch = true
        } label: {
          HStack {
            Text("Location")
            Spacer()
            if let savedLocation = WeatherSettings.defaultLocation {
              Text(savedLocation.name)
                .foregroundStyle(.secondary)
            } else {
              Text("Not Set")
                .foregroundStyle(.secondary)
            }
          }
        }
        
        if locationAuth.authorizationStatus == .notDetermined {
          Button("Enable Location Access") {
            locationAuth.requestPermission()
          }
        } else if locationAuth.authorizationStatus == .denied || locationAuth.authorizationStatus == .restricted {
          Text("Location access denied")
            .foregroundStyle(.secondary)
            .font(.caption)
          
          Button("Open Settings") {
            if let url = URL(string: "app-settings:") {
              openURL(url)
            }
          }
        }
      }
    }
    .sheet(isPresented: $showLocationSearch) {
      LocationSearchView { location in
        WeatherSettings.defaultLocation = location
      }
    }
  }
  
  private func binding<T>(for keyPath: ReferenceWritableKeyPath<WeatherSettings.Type, T>) -> Binding<T> {
    Binding(
      get: { WeatherSettings.self[keyPath: keyPath] },
      set: { WeatherSettings.self[keyPath: keyPath] = $0 }
    )
  }
}
#endif
