//
//  VehicleTileView.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import SwiftUI

struct VehicleTileView: View {
    @Environment(NavigationViewModel.self) var navManager

    let vehicle: VehicleModel
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 12) {
                AsyncImage(url: URL(string: vehicle.defaultImageUrlSmall ?? "")) { image in 
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } placeholder: {
                    Image(systemName: "car")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .frame(width: 50, height: 50)
                .cornerRadius(12)
                
                // Title and Subtitle aligned with image
                VStack(alignment: .leading, spacing: 4) {
                    Text(vehicle.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("\(vehicle.year?.description ?? "") \(vehicle.make ?? "") \(vehicle.model ?? "")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.bottom, 16)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    StatusBadge(name: vehicle.vehicleStatusName, color: vehicle.statusColor)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            navManager.navigate(to: .vehicleDetails(vehicle: vehicle))
        }
    }
}


