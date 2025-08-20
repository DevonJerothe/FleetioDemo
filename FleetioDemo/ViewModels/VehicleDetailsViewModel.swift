//
//  VehicleViewModel.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/19/25.
//

import SwiftUI

@Observable
class VehicleDetailsViewModel {

    private let vehicleRepository: VehicleRepositoryProtocol
    private let contactRepository: ContactRespositoryProtocol

    var vehicleDetails: VehicleModel?
    var contactDetails: ContactModel?
    var isLoading: Bool = false
    var error: APIError?

    init(
        repository: VehicleRepositoryProtocol = VehicleRepository(),
        contactRepository: ContactRespositoryProtocol = ContactRepository()
    ) {
        self.vehicleRepository = repository
        self.contactRepository = contactRepository
        self.vehicleDetails = nil
        self.error = nil
    }
    
    @MainActor
    func loadInitialData(id: String) async {
        if self.vehicleDetails == nil && isLoading == false {
            await loadVehicleDetails(id: id)
        }
    }

    @MainActor
    func loadVehicleDetails(id: String) async {
        isLoading = true

        /// The VehicleDriver obj on the details call has a little less info than on the list view
        /// - fullName
        /// - email
        /// Since we want to show the Contact tile and link to their view.. we should also load the ContactModel attached.
        do {
            let vehicleDetails = try await vehicleRepository.getVehicleDetails(id: id).get()
            if let driverId = vehicleDetails.driver?.id?.description {
                let contactDetails = try await contactRepository.getContact(id: driverId).get()
                self.contactDetails = contactDetails
            }
            
            self.vehicleDetails = vehicleDetails
        } catch(let error) {
            self.error = error
        }

        isLoading = false
    }
}
