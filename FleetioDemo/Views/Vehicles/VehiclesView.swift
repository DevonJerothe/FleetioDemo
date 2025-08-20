//
//  VehiclesView.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import SwiftUI

struct VehiclesView: View {

    @Environment(NavigationViewModel.self) var navManager
    @State private var viewModel: VehicleViewModel = VehicleViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // filter top bar
                makeFilterView()
                
                Spacer()
                
                // Check if we have any vehicles in the viewModel
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.blue)
                    Spacer()
                } else if viewModel.vehicles.isEmpty {
                    Text("No vehicles found for: \(viewModel.searchQuery)")
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.vehicles, id: \.id) { vehicle in
                            VehicleTileView(vehicle: vehicle)
                                .onAppear() {
                                    if vehicle.id == viewModel.vehicles.last?.id {
                                        Task {
                                            await viewModel.loadMoreItems()
                                        }
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Vehicles")
            .searchable(
                text: $viewModel.searchQuery, 
                placement: .navigationBarDrawer(displayMode: .always), 
                prompt: "Search"
            )
            .onSubmit(of: .search) {
                print("searching")
                Task {
                    await viewModel.searchItems()
                }
            }
            .onAppear() {
                Task {
                    // prevents us from reloading after inital data and navigating back
                    if viewModel.vehicles.isEmpty {
                        await viewModel.loadInitialData()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func makeFilterView() -> some View {
        HStack(spacing: 12) {
            // sort order
            Menu {
                Button {
                    viewModel.sortOrder = .desc
                    Task {
                        await viewModel.searchItems()
                    }
                } label: {
                    HStack {
                        Text("Descending")
                        if viewModel.sortOrder == .desc {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button {
                    viewModel.sortOrder = .asc
                    Task {
                        await viewModel.searchItems()
                    }
                } label: {
                    HStack {
                        Text("Ascending")
                        if viewModel.sortOrder == .asc {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                FilterItem(
                    defaultText: "Sort",
                    selectedText: viewModel.sortOrder.rawValue,
                    selectedColor: Color(.secondarySystemBackground),
                    icon: "arrow.up.arrow.down"
                )
            }
            .buttonStyle(.plain)
            
            // status filter
            if viewModel.statusFilters.isEmpty == false {
                Menu {
                    Button {
                        viewModel.statusFilter = nil
                        Task {
                            await viewModel.searchItems()
                        }
                    } label: {
                        HStack {
                            Text("All Statuses")
                            if viewModel.statusFilter == nil {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    ForEach(viewModel.statusFilters, id: \.id) { status in
                        Button {
                            viewModel.statusFilter = status
                            Task {
                                await viewModel.searchItems()
                            }
                        } label: {
                            HStack {
                                Text(status.name ?? "Unknown")
                                if viewModel.statusFilter?.id == status.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    FilterItem(
                        defaultText: "Status",
                        selectedText: viewModel.statusFilter?.name,
                        selectedColor: viewModel.statusFilter?.statusColor ?? Color(.secondarySystemBackground),
                        icon: "car.fill"
                    )
                }
                .buttonStyle(.plain)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}


