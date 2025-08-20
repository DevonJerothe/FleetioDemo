//
//  BaseViewModel.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/19/25.
//

import SwiftUI
import Combine

public enum FleetioSortOrder: String {
    case desc = "desc"
    case asc = "asc"
}

/// base level view model to handle pagination. Almost all services on the API look to support the same pagination.. 
/// This will alllow us better seperation of tasks. And make our view models a little smaller.. only the fetchData() function  
/// is required to be implemented in the subclass. 
@Observable
class PaginatedViewModel<T: Codable> {

    @ObservationIgnored private var searchCancellable: AnyCancellable?
    @ObservationIgnored var startCursor: String? = nil
    @ObservationIgnored var hasMore: Bool = true

    var items: [T] = []
    var isLoading: Bool = false
    var isLoadingNextPage: Bool = false
    var error: APIError? = nil
    var sortOrder: FleetioSortOrder = .asc

    var searchQuery: String = "" {
        didSet {
            if searchQuery != oldValue {
                debounceSearch()
            }
        }
    }

    @MainActor
    func loadInitialData() async {
        searchQuery.removeAll()
        startCursor = nil
        error = nil

        await loadItems()
    }

    @MainActor
    func searchItems() async {
        guard isLoading == false, isLoadingNextPage == false else {
            return
        }

        startCursor = nil
        error = nil

        await loadItems()
    }

    @MainActor
    func loadMoreItems() async {
        if hasMore && isLoadingNextPage == false {
            await loadItems(isPaging: true)
        }
    }

    @MainActor
    func loadItems(isPaging: Bool = false) async {
        guard isLoading == false, isLoadingNextPage == false else {
            return
        }

        if isPaging {
            isLoadingNextPage = true
        } else {
            isLoading = true
        }

        let results = await fetchData(isPaging: isPaging)

        switch results {
        case .success(let page): 
            if isPaging {
                items.append(contentsOf: page.records)
            } else {
                items = page.records
            }

            startCursor = page.nextCursor
            hasMore = page.nextCursor != nil
        case .failure(let error): 
            self.error = error
        }

        isLoading = false
        isLoadingNextPage = false
    }

    func fetchData(isPaging: Bool = false) async -> Result<FleetioPageResponse<T>, APIError> {
        fatalError("No Implementation is subclass")
    }

    private func debounceSearch() {
        searchCancellable?.cancel()

        searchCancellable = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .prefix(1)
            .sink { [weak self] _ in 
                guard let self else { return}

                Task {
                    await self.searchItems()
                }
            }
    }
}
