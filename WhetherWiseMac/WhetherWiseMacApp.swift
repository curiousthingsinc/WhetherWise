//
//  WhetherWiseMacApp.swift
//  WhetherWiseMac
//
//  Created by Eric Lobdell on 2/14/26.
//

import SwiftUI
import WhetherWiseCore

@main
struct WhetherWiseMacApp: App {
  var body: some Scene {
    MenuBarExtra("WhetherWise", systemImage: "sun.max.fill") {
      // Directly showing the shared Dashboard
      DashboardView()
        .frame(width: 300, height: 400)
      
      Divider()
      Button("Quit") {
        NSApplication.shared.terminate(nil)
      }
    }
    .menuBarExtraStyle(.window) // Makes it look like a pop-over
  }
}
