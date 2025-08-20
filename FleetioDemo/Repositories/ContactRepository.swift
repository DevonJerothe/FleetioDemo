//
//  ContactRepository.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/19/25.
//

import Foundation

public protocol ContactRespositoryProtocol {
    func getContacts(
        query: String?,
        sortBy: FleetioSortOrder?,
        filterStatus: String?,
        startCursor: String?,
        perPage: Int
    ) async -> Result<FleetioPageResponse<ContactModel>, APIError>
    
    func getContact(id: String) async -> Result<ContactModel, APIError>
}

/// TODO: I switched to a dictionary pattern late into building this, so I did not get to building out a better sort / filter UX component. For now we are building the sort dictionaries here
/// based on the force sort and filter options we have. The full solution would be to build these dictionaries within the viewModels and pass through to the service. That would allow us to fully control what we sort / filter by.
public class ContactRepository: ContactRespositoryProtocol, FleetioService {
    public var baseURL: String = "https://secure.fleetio.com/api"
    
    public func getContacts(
        query: String? = nil,
        sortBy: FleetioSortOrder? = .desc,
        filterStatus: String? = nil,
        startCursor: String? = nil,
        perPage: Int = 50
    ) async -> Result<FleetioPageResponse<ContactModel>, APIError> {
        
        var queryDict: [String: String] = [:]
        if let query, query.isEmpty == false {
            queryDict["email"] = query
//            queryDict["last_name"] = query
        }
        
        var sortDict: [String: String] = [:]
        if let sortBy {
            sortDict["updated_at"] = sortBy.rawValue
        }
        
        do {
            let response = try await self.getPage(
                for: ContactModel.self,
                "/contacts",
                query: queryDict,
                sortBy: sortDict,
                filterStatus: filterStatus,
                startCursor: startCursor,
                perPage: perPage
            )
            
            return .success(response)
        } catch(let error as APIError) {
            return .failure(error)
        } catch {
            return .failure(.unknownError(error.localizedDescription))
        }
    }
    
    public func getContact(id: String) async -> Result<ContactModel, APIError> {
        do {
            let response = try await self.getDetails(
                for: ContactModel.self,
                "/contacts",
                id: id
            )
            return .success(response)
        } catch (let error as APIError) {
            return .failure(error)
        } catch {
            return .failure(.unknownError(error.localizedDescription))
        }
    }
}
