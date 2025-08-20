//
//  NavigationViewModel.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import SwiftUI

@Observable
class NavigationViewModel {

    enum Tab: String {
        case vehicles = "Vehicles"
        case contacts = "Contact"
    }

    enum Destination: Hashable {
        case vehicleDetails(vehicle: VehicleModel)
        case contactDetails(contact: ContactModel)
    }

    enum SheetType: Identifiable {
        case commentSheet(comments: [VehicleComment])
        case mapSheet(location: LocationEntry)
        
        var id: String {
            switch self {
            case .commentSheet:
                return "commentSheet"
            case .mapSheet:
                return "mapSheet"
            }
        }
    }

    var currentTab: Tab = .vehicles
    var presentedSheet: SheetType?
    var vehiclesPath = NavigationPath()
    var contactspath = NavigationPath()
    
    private func addToCurrentPath(_ destination: Destination) {
        switch currentTab {
        case .vehicles:
            vehiclesPath.append(destination)
        case .contacts:
            contactspath.append(destination)
        }
    }

    public func popBack() {
        switch currentTab {
        case .vehicles:
            if !vehiclesPath.isEmpty {
                vehiclesPath.removeLast()
            }
        case .contacts:
            if !contactspath.isEmpty {
                contactspath.removeLast()
            }
        }
    }

    public func showCommentsSheet(comments: [VehicleComment]) {
        presentedSheet = .commentSheet(comments: comments)
    }

    public func showMapSheet(location: LocationEntry) {
        presentedSheet = .mapSheet(location: location)
    }
    
    public func navigate(to destination: Destination) {
        self.addToCurrentPath(destination)
    }
}
