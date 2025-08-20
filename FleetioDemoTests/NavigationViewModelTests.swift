//
//  NavigationViewModelTests.swift
//  FleetioDemoTests
//
//  Created by devon jerothe on 8/18/25.
//

import Testing
import SwiftUI
@testable import FleetioDemo

@Suite("NavigationViewModelTests")
@MainActor
struct NavigationViewModelTests {
    
    var vm: NavigationViewModel
    let mockVehicle: VehicleModel = .makeMock
    let mockContact: ContactModel = .makeMock

    init() {
        self.vm = NavigationViewModel()
    }
    

    // MARK: - Test navigate() function
    @Test func testNavigate() async throws {
        let destination1 = NavigationViewModel.Destination.vehicleDetails(vehicle: mockVehicle)
        let destination2 = NavigationViewModel.Destination.contactDetails(contact: mockContact)
        
        #expect(vm.currentTab == .vehicles)
        #expect(vm.vehiclesPath.count == 0)
        #expect(vm.contactspath.count == 0)
        
        vm.navigate(to: destination1)
        vm.currentTab = .contacts
        vm.navigate(to: destination2)
        
        // both tabs should now have destinations in path
        #expect(vm.currentTab == .contacts)
        #expect(vm.vehiclesPath.count == 1)
        #expect(vm.contactspath.count == 1)
    }
    
    @Test func testPopBack() {
        let destination1 = NavigationViewModel.Destination.vehicleDetails(vehicle: mockVehicle)
        let destination2 = NavigationViewModel.Destination.contactDetails(contact: mockContact)
        
        #expect(vm.currentTab == .vehicles)
        vm.navigate(to: destination1)
        vm.navigate(to: destination2)
        
        #expect(vm.vehiclesPath.count == 2)
        vm.popBack()
        #expect(vm.vehiclesPath.count == 1)
    }
}
