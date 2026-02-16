//
//  SwiftUIView.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/16/26.
//

import SwiftUI

struct SettingsFormView: View {
    var body: some View {
      Form {
        WeatherSettingsView()
      }
    }
}

#Preview {
  SettingsFormView()
}
