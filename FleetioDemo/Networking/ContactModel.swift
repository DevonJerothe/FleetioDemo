//
//  ContactModel.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import Foundation

// MARK: - ContactModel
public struct ContactModel: Codable, Hashable {
    let id: Int?
    let createdAt: String?
    let updatedAt: String?
    let email: String?
    let fullName: String? 
    let name: String?
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let groupId: Int?
    let groupName: String?
    let groupHierarchy: String?
    let technician: Bool?
    let vehicleOperator: Bool?
    let employee: Bool?
    let birthDate: String?
    let streetAddress: String?
    let streetAddressLine2: String?
    let city: String?
    let region: String?
    let postalCode: String?
    let country: String?
    let employeeNumber: String?
    let jobTitle: String?
    let licenseClass: String?
    let licenseNumber: String?
    let licenseState: String?
    let homePhoneNumber: String?
    let mobilePhoneNumber: String?
    let workPhoneNumber: String?
    let otherPhoneNumber: String?
    let startDate: String?
    let leaveDate: String?
    let hourlyLaborRateCents: Int?
    let attachmentPermissions: AttachmentPermissions?
    let defaultImageUrl: String?
    let accountMembershipId: Int?
    let lastApiRequest: String?
    let lastWebAccess: String?
    let lastMobileAppAccess: String?
    let images: [ContactImage]?
    let imagesCount: Int?
}

// MARK: - AttachmentPermissions
public struct AttachmentPermissions: Codable, Hashable {
    let readPhotos: Bool?
    let managePhotos: Bool?
    let readDocuments: Bool?
    let manageDocuments: Bool?
}

// MARK: - ContactImage
public struct ContactImage: Codable, Hashable {
    let id: Int?
    let createdAt: String?
    let updatedAt: String?
    let imageableId: Int?
    let imageableType: String?
    let fileName: String?
    let fileMimeType: String?
    let fileSize: Int?
    let fileUrl: String?
    let fullUrl: String?
}

// MARK: - Mocks 
extension ContactModel {
    static var makeMock: ContactModel {
        guard let url = Bundle.main.url(forResource: "contacts", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            fatalError("Cant load mock Json")
        }
        
        let decoder = JSONDecoder()

        // or we can use coding keys 
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let contact = try? decoder.decode(ContactModel.self, from: data) else {
            fatalError("Cant decode mock Json")
        }

        return contact
    }
}
