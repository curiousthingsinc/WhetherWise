//
//  SwiftUIView.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/16/26.
//
#if os(macOS)
import SwiftUI
import CoreLocation

struct WeatherSettingsView_macOS: View {
  @State private var refresh = false
  @State private var locationStatus: CLAuthorizationStatus = {
    CLLocationManager().authorizationStatus
  }()
  @State private var locationManager = LocationAuthManager()
  @State private var showLocationSearch = false
  
  var body: some View {
    Form {
      LabeledContent("Temperature:") {
        Picker("", selection: binding(for: \.temperatureUnit)) {
          Text("Celsius (°C)").tag(TemperatureUnitPreference.celsius)
          Text("Fahrenheit (°F)").tag(TemperatureUnitPreference.fahrenheit)
        }
        .labelsHidden()
      }
      
      LabeledContent("Pressure:") {
        Picker("", selection: binding(for: \.pressureUnit)) {
          Text("Hectopascals (hPa)").tag(PressureUnitPreference.hectopascals)
          Text("Inches of Mercury (inHg)").tag(PressureUnitPreference.inchesOfMercury)
          Text("Millibars (mb)").tag(PressureUnitPreference.millibars)
        }
        .labelsHidden()
      }
      
      LabeledContent("Distance:") {
        Picker("", selection: binding(for: \.distanceUnit)) {
          Text("Kilometers (km)").tag(DistanceUnitPreference.kilometers)
          Text("Miles (mi)").tag(DistanceUnitPreference.miles)
        }
        .labelsHidden()
      }
      
      LabeledContent("Speed:") {
        Picker("", selection: binding(for: \.speedUnit)) {
          Text("m/s").tag(SpeedUnitPreference.metersPerSecond)
          Text("km/h").tag(SpeedUnitPreference.kilometersPerHour)
          Text("mph").tag(SpeedUnitPreference.milesPerHour)
        }
        .labelsHidden()
      }
      
      LabeledContent("Precipitation:") {
        Picker("", selection: binding(for: \.lengthUnit)) {
          Text("Millimeters (mm)").tag(LengthUnitPreference.millimeters)
          Text("Inches (in)").tag(LengthUnitPreference.inches)
        }
        .labelsHidden()
      }
      
      Divider()
      
      if locationStatus == .authorizedAlways {
        Toggle("Use Current Location", isOn: binding(for: \.useCurrentLocation))
        
        if !WeatherSettings.useCurrentLocation {
          LabeledContent("Location:") {
            Button(WeatherSettings.defaultLocation?.name ?? "Select Location") {
              showLocationSearch = true
            }
          }
        }
      } else {
        LabeledContent("Location:") {
          Button(WeatherSettings.defaultLocation?.name ?? "Select Location") {
            showLocationSearch = true
          }
        }
        
        if locationStatus == .notDetermined {
          Button("Enable Location Access") {
            requestLocationPermission()
          }
        } else if locationStatus == .denied || locationStatus == .restricted {
          Text("Location access denied. Enable in System Settings.")
            .foregroundStyle(.secondary)
            .font(.caption)
        }
      }
    }
    .formStyle(.grouped)
    .frame(minWidth: 500, minHeight: 400)
    .id(refresh)
    .onAppear {
      updateLocationStatus()
    }
    .sheet(isPresented: $showLocationSearch) {
      LocationSearchView { location in
        WeatherSettings.defaultLocation = location
        refresh.toggle()
      }
      .frame(width: 500, height: 600)
    }
  }
  
  private func updateLocationStatus() {
    locationStatus = CLLocationManager().authorizationStatus
  }
  
  private func requestLocationPermission() {
    locationManager.requestPermission()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      updateLocationStatus()
    }
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
#endif
