import SwiftUI
import MapKit

struct LocationSearchView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var viewModel = LocationSearchViewModel()
  
  // The callback to return the selected data
  var onSelect: (WhetherRuleLocation) -> Void
  
  var body: some View {
    NavigationStack {
      ZStack {
        List(viewModel.results, id: \.self) { result in
          Button {
            Task {
              if let location = await viewModel.selectLocation(result) {
                onSelect(location)
                dismiss()
              }
            }
          } label: {
            VStack(alignment: .leading) {
              Text(result.title)
                .font(.headline)
                .foregroundStyle(.primary)
              
              if !result.subtitle.isEmpty {
                Text(result.subtitle)
                  .font(.caption)
                  .foregroundStyle(.secondary)
              }
            }
            .padding(.vertical, 4) // Breathing room for Mac mouse users
          }
          .buttonStyle(.plain) // Removes default blue link color on iOS/Mac
        }
        .overlay {
          if viewModel.results.isEmpty && !viewModel.queryFragment.isEmpty {
            ContentUnavailableView("No Results", systemImage: "magnifyingglass", description: Text("Check the spelling or try a new search."))
          } else if viewModel.results.isEmpty {
            ContentUnavailableView("Search Location", systemImage: "location.magnifyingglass", description: Text("Start typing to find a city."))
          }
        }
        
        // Loading Overlay
        if viewModel.isLoading {
          ProgressView()
            .controlSize(.large)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(8)
        }
      }
      .searchable(text: $viewModel.queryFragment, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a city...")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(.secondary)
              .symbolVariant(.circle.fill)
              .font(.title3)
          }
          .buttonStyle(.plain)
          .accessibilityLabel("Close")
          .interactiveDismissDisabled(viewModel.isLoading)
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var isPresented = true
  
  VStack {
    if isPresented {
      LocationSearchView { location in
        print("Selected: \(location.name), \(location.latitude), \(location.longitude), \(location.timeZoneID)")
        isPresented = false
      }
    } else {
      Button("Re-open Search") { isPresented = true }
    }
  }
}
