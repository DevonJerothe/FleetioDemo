//
//  VehicleDetailsView.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import SwiftUI 

struct VehicleDetailsView: View {
    @Environment(NavigationViewModel.self) var navManager

    /// The original idea here was to load the vehicle details from the list model, however it did not include location
    /// and comment data.
    ///
    /// I'm still passing the VehicleModel to the view but only using the Id and fetching it again with the additional details.
    /// we should be just passing the id string instead if we keep it this way. Alternatively the better option would be loading the
    /// view with the provided model, then loading in the rest by updating the model. (similar behaviour to your existing app I believe)
    let vehicleDetails: VehicleModel
    @State var viewModel: VehicleDetailsViewModel = .init()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.blue)
                Spacer()
            } else if let details = viewModel.vehicleDetails {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .top, spacing: 16) {
                            AsyncImage(url: URL(string: details.defaultImageUrlLarge ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Image(systemName: "car")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 125, height: 100)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        VehicleInfoRow(label: "Year", value: details.year?.description ?? "Not Set")
                                        VehicleInfoRow(label: "Make", value: details.make ?? "Not Set")
                                    }
                                    VStack(alignment: .leading, spacing: 8) {
                                        VehicleInfoRow(label: "Model", value: details.model ?? "Not Set")
                                        VehicleInfoRow(label: "Trim", value: details.trim ?? "Not Set")
                                    }
                                }
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Vehicle Details")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                                StatusBadge(name: details.vehicleStatusName, color: details.statusColor)
                            }

                            
                            VStack(spacing: 0) {
                                DetailRow(label: "License Plate", value: details.licensePlate ?? "Not Set")
                                Divider()
                                DetailRow(label: "VIN", value: details.vin)
                                Divider()
                                DetailRow(label: "Color", value: details.color)
                                Divider()
                                DetailRow(label: "Ownership", value: details.ownership)
                                Divider()
                                DetailRow(label: "Vehicle Type", value: details.vehicleTypeName)
                            }
                            .cardModifier()
                        }
                        
                        if let meterPrimary = details.primaryMeterValue {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Meter Information")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                VStack(spacing: 0) {
                                    DetailRow(label: "Primary Meter", value: "\(meterPrimary) \(details.primaryMeterUnit ?? "")")
                                    
                                    if let meterSecondary = details.secondaryMeterValue, let meterUnit = details.secondaryMeterUnit{
                                        Divider()
                                        DetailRow(label: "Secondary Meter", value: "\(meterSecondary) \(meterUnit)")
                                    }
                                }
                                .cardModifier()
                            }
                        }
                        
                        if let contact = viewModel.contactDetails {
                            ContactTileView(contact: contact)
                                .cardModifier()
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Activity")
                                .font(.headline)
                                .fontWeight(.semibold)

                            // TODO: add comment section that opens bottom sheet 
                            HStack {
                                Text("Discussions")
                                    .foregroundStyle(.secondary)
                                Spacer() 
                                Text("\(details.commentsCount ?? 0)")
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .cardModifier()
                            .onTapGesture {
                                if let comments = details.comments {
                                    navManager.showCommentsSheet(comments: comments)
                                }
                            }

                            if let location = details.currentLocationEntry, location.id != nil {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Last Location")
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text("\(location.address ?? "")")
                                    }
                                    Spacer() 
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .cardModifier()
                                .onTapGesture {
                                    navManager.showMapSheet(location: location)
                                }
                            }

                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                StatusCard(title: "Work Orders", count: details.workOrdersCount ?? 0, icon: "wrench.and.screwdriver")
                                StatusCard(title: "Service Entries", count: details.serviceEntriesCount ?? 0, icon: "gear")
                                StatusCard(title: "Fuel Entries", count: details.fuelEntriesCount ?? 0, icon: "fuelpump")
                                StatusCard(title: "Issues", count: details.issuesCount ?? 0, icon: "exclamationmark.triangle")
                            }
                        }
                    }
                    .padding()
                }
            } else {
                Spacer()
                Text("Details Not Available")
                Spacer()
            }
        }
        .navigationTitle(vehicleDetails.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            Task {
                await viewModel.loadInitialData(id: String(vehicleDetails.id))
            }
        }
    }
}

struct VehicleInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}
