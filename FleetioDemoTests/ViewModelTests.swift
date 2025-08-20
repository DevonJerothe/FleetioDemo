//
//  ViewModelTests.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/20/25.
//

import Testing 
import Foundation 
@testable import FleetioDemo

@Suite("ViewModelTests")
@MainActor 
struct ViewModelTests {

    var vm: VehicleViewModel
    var repo: MockVehicleRepo = .init()
    
    let mockVehicle: VehicleModel = .makeMock
    
    init() {
        self.vm = VehicleViewModel(repository: repo)
    }

    @Test func testLoadInitialData() async {

        repo.mockVehicles = [mockVehicle]

        #expect(vm.items.count == 0)
        #expect(vm.isLoading == false)
        #expect(vm.searchQuery.isEmpty)

        await vm.loadInitialData()
        #expect(vm.isLoading == false)
        #expect(vm.vehicles.count == 1)
        #expect(vm.statusFilters.count == 0)
        
        // loading initial should reset items
        repo.mockVehicles = [mockVehicle, mockVehicle]
        await vm.loadInitialData()
        #expect(vm.vehicles.count == 2)
    }
    
    @Test func testLoadMoreData() async {
        repo.mockVehicles = [mockVehicle, mockVehicle]

        // setting items in the base model should reflect when calling vehicles 
        vm.items = [mockVehicle]
        #expect(vm.vehicles.count == 1)

        // should stop loading mor from fetching our 2 additional mocks
        vm.hasMore = false
        await vm.loadMoreItems()
        #expect(vm.vehicles.count == 1)

        vm.hasMore = true
        await vm.loadMoreItems()
        #expect(vm.vehicles.count == 3)

        // make sure hasMore can auto set based on paging 
        vm.hasMore = false 
        repo.nextCursor = "1"
        await vm.loadInitialData()
        #expect(vm.hasMore == true)
        #expect(vm.vehicles.count == 2)

        repo.nextCursor = nil
        await vm.loadMoreItems()
        #expect(vm.vehicles.count == 4)
        #expect(vm.hasMore == false)
    }

    @Test func testFailures() async {
        repo.forceFail = true
        await vm.loadInitialData()
        #expect(vm.error?.errorDescription == "Testing.")

        repo.forceFail = false
        await vm.loadInitialData()
        #expect(vm.error == nil)
    }
}


class MockVehicleRepo: VehicleRepositoryProtocol {
    var forceFail: Bool = false 
    var mockVehicles: [VehicleModel] = []
    var mockStatusFilters: [StatusFilterModel] = []
    var nextCursor: String? = nil 
    
    func getVehicles(
        query: String?,
        sortBy: FleetioSortOrder?,
        filterStatus: String?,
        startCursor: String?,
        perPage: Int
    ) async -> Result<FleetioPageResponse<VehicleModel>, APIError>{
        if forceFail {
            return .failure(.unknownError("Testing."))
        }

        let response = FleetioPageResponse<VehicleModel>(
            startCursor: startCursor,
            nextCursor: nextCursor,
            perPage: perPage, 
            estimatedRemainingCount: nil,
            records: mockVehicles,
        )

        return .success(response)
    }

    func getVehicleDetails(id: String) async -> Result<VehicleModel, APIError> {
        if forceFail {
            return .failure(.unknownError("Testing."))
        }

        return .success(VehicleModel.makeMock)
    }

    func getStatusFilters() async -> Result<FleetioPageResponse<StatusFilterModel>, APIError> {
        if forceFail {
            return .failure(.unknownError("Testing."))
        }

        let response = FleetioPageResponse<StatusFilterModel>(
            startCursor: nil,
            nextCursor: nil,
            perPage: 50,
            estimatedRemainingCount: nil,
            records: mockStatusFilters,
        )

        return .success(response)
    }
}
