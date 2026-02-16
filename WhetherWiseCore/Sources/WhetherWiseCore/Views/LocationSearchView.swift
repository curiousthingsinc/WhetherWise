import SwiftUI
import MapKit

struct LocationSearchView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var viewModel = LocationSearchViewModel()
  
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
              
              if !result.subtitle.isEmpty {
                Text(result.subtitle)
                  .font(.caption)
                  .foregroundStyle(.secondary)
              }
            }
            .padding(.vertical, 4)
          }
          .buttonStyle(.plain)
        }
        .searchable(text: $viewModel.queryFragment, prompt: "Search for a city...")
        .overlay {
          if viewModel.results.isEmpty && !viewModel.queryFragment.isEmpty {
            ContentUnavailableView("No Results", systemImage: "magnifyingglass", description: Text("Check the spelling or try a new search."))
          } else if viewModel.results.isEmpty {
            ContentUnavailableView("Search Location", systemImage: "location.magnifyingglass", description: Text("Start typing to find a city."))
          }
        }
        
        if viewModel.isLoading {
          ProgressView()
            .controlSize(.large)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(8)
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
