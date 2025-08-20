//
//  VehicleModel.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import Foundation
import SwiftUI

// MARK: - Vehicle
public struct VehicleModel: Codable, Hashable {
    let id: Int
    let accountId: Int?
    let archivedAt: String?
    let fuelTypeId: Int?
    let fuelTypeName: String?
    let fuelVolumeUnits: String?
    let groupId: Int?
    let groupName: String?
    let name: String
    let ownership: String
    let currentLocationEntryId: Int?
    let currentLocationEntry: LocationEntry?
    let systemOfMeasurement: String?
    let vehicleTypeId: Int?
    let vehicleTypeName: String?
    let isSample: Bool?
    let vehicleStatusId: Int
    let vehicleStatusName: String
    let vehicleStatusColor: String?
    let primaryMeterUnit: String?
    let primaryMeterValue: String?
    let primaryMeterDate: String?
    let primaryMeterUsagePerDay: String?
    let secondaryMeterUnit: String?
    let secondaryMeterValue: String?
    let secondaryMeterDate: String?
    let secondaryMeterUsagePerDay: String?
    let inServiceMeterValue: String?
    let inServiceDate: String?
    let outOfServiceMeterValue: String?
    let outOfServiceDate: String?
    let estimatedServiceMonths: Int?
    let estimatedReplacementMileage: String?
    let estimatedResalePriceCents: Int?
    let fuelEntriesCount: Int?
    let serviceEntriesCount: Int?
    let serviceRemindersCount: Int?
    let vehicleRenewalRemindersCount: Int?
    let comments: [VehicleComment]?
    let commentsCount: Int?
    let documentsCount: Int?
    let imagesCount: Int?
    let issuesCount: Int?
    let workOrdersCount: Int?
    let labels: [VehicleLabel]?
    let groupAncestry: String?
    let color: String?
    let licensePlate: String?
    let vin: String?
    let year: Int?
    let make: String?
    let model: String?
    let trim: String?
    let registrationExpirationMonth: Int?
    let registrationState: String?
    let defaultImageUrlSmall: String?
    let defaultImageUrlMedium: String?
    let defaultImageUrlLarge: String?
    let aiEnabled: Bool?
    let assetableType: String?
    let axleConfigId: Int?
    let driver: VehicleDriver?
    
    // color on vehichle is descriptive text, but on the status object its hex.
    var statusColor: Color {
        guard let colorString = self.vehicleStatusColor else {
            return .gray
        }
        
        if colorString == "blue" {
            return .blue
        }
        if colorString == "red" {
            return .red
        }
        if colorString == "green" || colorString == "lime" || colorString == "olive" {
            return .green
        }
        if colorString == "purple" {
            return .purple
        }
        
        return .gray
    }
}

// MARK: - VehicleLabel
public struct VehicleLabel: Codable, Hashable {
    let id: Int?
    let name: String?
}

public struct VehicleComment: Codable, Hashable {
    let id: Int
    let comment: String
    let commentableId: Int
    let createdAt: String
    let updatedAt: String
    let htmlContent: String
    let userId: Int
    let userImageUrl: String?
}

// MARK: - VehicleDriver
public struct VehicleDriver: Codable, Hashable {
    let id: Int?
    let email: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let fullName: String?
    let groupId: Int?
    let employee: Bool?
    let employeeNumber: String?
    let defaultImageUrl: String?
}

public struct LocationEntry: Codable, Hashable {
    let id: Int? 
    let vehicleId: Int?
    let date: String? 
    let geolocation: GeoLocation?
    let address: String?
}

public struct GeoLocation: Codable, Hashable {
    let latitude: Double?
    let longitude: Double?
}

// MARK: - StatusFilterModel
public struct StatusFilterModel: Codable {
    let id: Int?
    let createdAt: String?
    let updatedAt: String?
    let accountId: Int?
    let name: String?
    let isDefault: Bool?
    let color: String?
    let position: Int?
    
    // color on vehichle is descriptive text, but on the status object its hex.
    var statusColor: Color {
        guard let colorString = self.color else {
            return .gray
        }
        
        if colorString == "blue" {
            return .blue
        }
        if colorString == "red" {
            return .red
        }
        if colorString == "green" || colorString == "lime" || colorString == "olive" {
            return .green
        }
        if colorString == "purple" {
            return .purple
        }
        
        return .gray
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case updatedAt
        case accountId
        case name
        case isDefault = "default"
        case color
        case position
    }
}

// MARK: = Mocks
extension VehicleModel {
    static var makeMock: VehicleModel {
        guard let url = Bundle.main.url(forResource: "vehicle", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            fatalError("Cant load mock Json")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let vehicle = try? decoder.decode(VehicleModel.self, from: data) else {
            fatalError("Cant decode mock Json")
        }

        return vehicle
    }
}
