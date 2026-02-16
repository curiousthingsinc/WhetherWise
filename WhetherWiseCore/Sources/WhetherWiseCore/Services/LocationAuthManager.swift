//
//  LocationAuthManager.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/16/26.
//

import Foundation
import CoreLocation

@MainActor
class LocationAuthManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published var authorizationStatus: CLAuthorizationStatus
  private let manager = CLLocationManager()
  
  override init() {
    self.authorizationStatus = manager.authorizationStatus
    super.init()
    manager.delegate = self
  }
  
  func requestPermission() {
    manager.requestWhenInUseAuthorization()
  }
  
  nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    Task { @MainActor in
      self.authorizationStatus = self.manager.authorizationStatus
    }
  }
}
