//
//  Persistence.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/14/26.
//

import SwiftData
import Foundation

public actor PersistenceController {
  public static let shared = PersistenceController()
  
  public let container: ModelContainer
  
  init() {
    // 1. Define the Schema (all your @Model classes)
    let schema = Schema([WhetherRule.self])
    
    // 2. Point to the App Group container
    let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.co.curiousthings.WhetherWise")!
    let storeURL = groupURL.appendingPathComponent("WhetherWise.store")
    
    // 3. Configure for iCloud
    let config = ModelConfiguration(url: storeURL, cloudKitDatabase: .private("iCloud.co.curiousthings.WhetherWise"))
    
    do {
      container = try ModelContainer(for: schema, configurations: [config])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }
}
