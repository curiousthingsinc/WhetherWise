//
//  ContentView.swift
//  WhetherWise
//
//  Created by Eric Lobdell on 2/14/26.
//

import SwiftUI
import WhetherWiseCore
import SwiftData

struct ContentView: View {
  @State private var selectedTab: Tab? = .dashboard
  
  enum Tab: Hashable, CaseIterable {
    case dashboard, rules, settings
    
    var title: String {
      switch self {
      case .dashboard: return "Dashboard"
      case .rules: return "Rules"
      case .settings: return "Settings"
      }
    }
    
    var icon: String {
      switch self {
      case .dashboard: return "aqi.medium"
      case .rules: return "list.bullet.indent"
      case .settings: return "gearshape"
      }
    }
  }
  
  var body: some View {
    NavigationSplitView {
      // Sidebar for iPad / Tab Bar for iPhone
      List(Tab.allCases, id: \.self, selection: $selectedTab) { tab in
        Label(tab.title, systemImage: tab.icon)
      }
      .navigationTitle("WhetherWise")
    } detail: {
      // The content area
      if let selectedTab {
        switch selectedTab {
        case .dashboard:
          DashboardView() // Shared from Core
        case .rules:
          Text("Rules Screen")
        case .settings:
          Text("Settings Screen")
        }
      }
    }
  }
}


