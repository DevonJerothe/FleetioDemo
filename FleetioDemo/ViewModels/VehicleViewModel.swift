//
//  VehicleViewModel.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import SwiftUI
import Combine

// public enum SortOrder: String {
//     case desc = "desc"
//     case asc = "asc"
// }

@Observable
class VehicleViewModel: PaginatedViewModel<VehicleModel> {

    private let vehicleRepository: VehicleRepositoryProtocol

    var vehicles: [VehicleModel] { items }
    var statusFilters: [StatusFilterModel] = []
    var isLoadingFilters: Bool = false

    var statusFilter: StatusFilterModel? = nil

    init(
        repository: VehicleRepositoryProtocol = VehicleRepository()
    ) {
        self.vehicleRepository = repository
    }
    
    override func loadInitialData() async {
        await super.loadInitialData()
        await loadFilters()
    }
    override func fetchData(isPaging: Bool = false) async -> Result<FleetioPageResponse<VehicleModel>, APIError> {
        await vehicleRepository.getVehicles(
            query: searchQuery,
            sortBy: sortOrder,
            filterStatus: nil,
            startCursor: startCursor,
            perPage: 50
        )
    }

    @MainActor
    func loadVehicleDetails(id: String) async -> VehicleModel? {
        let details = await vehicleRepository.getVehicleDetails(id: id)
        switch details {
        case .success(let vehicle):
            return vehicle
        case .failure(let error):
            self.error = error
            return nil
        }
    }
    
    @MainActor
    private func loadFilters() async {
        isLoadingFilters = true
        
        let statusFilters = await vehicleRepository.getStatusFilters()
        switch statusFilters {
        case .success(let filters):
            self.statusFilters = filters.records
        case .failure(let error):
            self.error = error
        }
        
        isLoadingFilters = false
    }
}

