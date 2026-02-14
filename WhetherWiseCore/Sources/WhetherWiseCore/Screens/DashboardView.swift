//
//  SwiftUIView.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/14/26.
//

import SwiftUI

public struct DashboardView: View {
  public init() {}
  
  public var body: some View {
    VStack {
      Image(systemName: "sun.max.fill")
        .font(.system(size: 50))
        .foregroundColor(.yellow)
      Text("Dashboard")
        .font(.largeTitle)
        .bold()
      Text("Weather logic from Core Package")
        .foregroundColor(.secondary)
    }
  }
}

#Preview {
  DashboardView()
}
