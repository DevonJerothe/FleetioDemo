//
//  ContactsViewModel.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/19/25.
//

import SwiftUI
import Combine

@Observable
class ContactsViewModel: PaginatedViewModel<ContactModel> {
    
    private let contactsRepository: ContactRespositoryProtocol
    
    var contacts: [ContactModel] = []
    
    init(
        repository: ContactRespositoryProtocol = ContactRepository()
    ) {
        self.contactsRepository = repository
    }
    
    override func fetchData(isPaging: Bool = false) async -> Result<FleetioPageResponse<ContactModel>, APIError> {
        await contactsRepository.getContacts(
            query: searchQuery,
            sortBy: sortOrder,
            filterStatus: nil,
            startCursor: startCursor,
            perPage: 50
        )
    }
}
