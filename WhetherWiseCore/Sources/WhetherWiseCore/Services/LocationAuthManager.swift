//
//  LocationAuthManager.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/16/26.
//

import Foundation
import CoreLocation

class LocationAuthManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published var authorizationStatus: CLAuthorizationStatus
  private let manager = CLLocationManager()
  
  override init() {
    self.authorizationStatus = manager.authorizationStatus
    super.init()
    manager.delegate = self
  }
  
  func requestPermission() {
    print("🔵 Requesting location permission...")
    print("🔵 Current status: \(manager.authorizationStatus.rawValue)")
    manager.requestWhenInUseAuthorization()
    print("🔵 Request sent")
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("🟢 Authorization changed to: \(manager.authorizationStatus.rawValue)")
    authorizationStatus = manager.authorizationStatus
  }
}
