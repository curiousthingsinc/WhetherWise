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
#if os(iOS)
        WeatherSettingsView_iOS()
#elseif os(macOS)
        WeatherSettingsView_macOS()
#endif
      }
    }
}

#Preview {
  SettingsFormView()
}
