//
//  Persistence.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/14/26.
//

import SwiftData
import Foundation

public struct PersistenceController: Sendable {
  public static let shared = PersistenceController()
  
  // Remove @MainActor - container can be accessed from any thread
  public let container: ModelContainer
  
  private init() {
    let schema = Schema([
      WhetherRule.self,
      WhetherCondition.self
    ])
    
    let appGroupID = "group.co.curiousthings.WhetherWise"
    
    guard let appGroupURL = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: appGroupID
    ) else {
      fatalError("App Group '\(appGroupID)' not found. Check Signing & Capabilities.")
    }
    
    let storeURL = appGroupURL.appendingPathComponent("WhetherWise.sqlite")
    
    print("📦 SwiftData store location: \(storeURL.path)")
    
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      url: storeURL,
      cloudKitDatabase: .none
    )
    
    do {
      // ModelContainer itself is thread-safe
      container = try ModelContainer(for: schema, configurations: [modelConfiguration])
      print("✅ ModelContainer created successfully")
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }
}
