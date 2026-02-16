//
//  LocationSearchViewModel.swift
//  WhetherWiseCore
//
//  Created by Eric Lobdell on 2/14/26.
//

import SwiftUI
import MapKit
import Combine

public class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate, @unchecked Sendable {
  @Published var queryFragment: String = ""
  @Published var results: [MKLocalSearchCompletion] = []
  @Published var isLoading: Bool = false
  
  private let completer = MKLocalSearchCompleter()
  private var cancellables = Set<AnyCancellable>()
  
  override init() {
    super.init()
    completer.delegate = self
    completer.resultTypes = .address
    
    $queryFragment
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .sink { [weak self] query in
        if query.isEmpty {
          self?.results = []
        } else {
          self?.completer.queryFragment = query
        }
      }
      .store(in: &cancellables)
  }
  
  // MARK: - Delegate Methods
  public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    self.results = completer.results
  }
  
  public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    self.results = []
  }
  
  // MARK: - Selection Logic
  public func selectLocation(_ completion: MKLocalSearchCompletion) async -> WhetherRuleLocation? {
    isLoading = true
    defer { isLoading = false }
    
    let request = MKLocalSearch.Request(completion: completion)
    let search = MKLocalSearch(request: request)
    
    guard let response = try? await search.start(),
          let item = response.mapItems.first else { return nil }
    
    return WhetherRuleLocation(
      name: completion.title,
      latitude: item.placemark.coordinate.latitude,
      longitude: item.placemark.coordinate.longitude,
      timeZoneID: item.timeZone?.identifier ?? "UTC"
    )
  }
}

#if DEBUG
extension LocationSearchViewModel {
  static var sample: LocationSearchViewModel {
    let vm = LocationSearchViewModel()
    vm.queryFragment = "New York"
    return vm
  }
}
#endif
