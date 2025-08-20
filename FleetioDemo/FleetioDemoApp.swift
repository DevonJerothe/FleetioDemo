//
//  FleetioDemoApp.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import SwiftUI

@main
struct FleetioDemoApp: App {

    /// We could also make this a singleton or add to a dependency container along with repositories
    // if we want easier access directly from non views as well. We will stick with EnvObj and pass to VM for now.
    @State private var navigationViewModel = NavigationViewModel()

    /// NavigationStack with destinations at the top level allows for a better control of how we move between screens and tabs. It alows for a more programatic approach that I think its cleaner.
    /// We can set up simple routes within our viewModel to navigate anwhere from anywhere while maintaining tabs independently.
    ///
    /// TODO: This can also be extended to sheet / banner control to allow handling the API error messages.
    var body: some Scene {
        WindowGroup {
            TabView(selection: $navigationViewModel.currentTab) {
                NavigationStack(path: $navigationViewModel.vehiclesPath) {
                    VehiclesView()
                        .navigationDestination(for: NavigationViewModel.Destination.self) { destination in
                            destinationView(for: destination)
                        }
                }
                .tabItem {
                    Label("Vehicles", systemImage: "car")
                }
                .tag(NavigationViewModel.Tab.vehicles)
                
                NavigationStack(path: $navigationViewModel.contactspath) {
                    ContactsView()
                        .navigationDestination(for: NavigationViewModel.Destination.self) { destination in
                            destinationView(for: destination)
                        }
                }
                .tabItem {
                    Label("Operators", systemImage: "person")
                }
                .tag(NavigationViewModel.Tab.contacts)
            }
            .sheet(item: $navigationViewModel.presentedSheet) { sheet in 
                sheetView(for: sheet)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(.thinMaterial)
            }
        }
        .environment(navigationViewModel)
    }

    @ViewBuilder
    func destinationView(for destination: NavigationViewModel.Destination) -> some View {
        switch destination {
        case .vehicleDetails(let vehicle):
            VehicleDetailsView(vehicleDetails: vehicle)
        case .contactDetails(let contact):
            ContactDetailsView(contactDetails: contact)
        }
    }

    @ViewBuilder
    func sheetView(for sheet: NavigationViewModel.SheetType) -> some View {
        switch sheet {
        case .commentSheet(let comments):
            CommentsSheetView(comments: comments)
        case .mapSheet(let location):
            MapViewSheet(lastLocation: location)
        }
    }
}

