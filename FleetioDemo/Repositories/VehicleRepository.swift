//
//  VehicleRepository.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import Foundation 

/// We can improve our networking an repositories by creating a generic BaseRepositoryProtocol. 
/// this would prevent us from having to re-implement the same page methods for each service if we where to implement more of them.
/// And since we also have the same error handling it would be a good idea to move.  
public protocol VehicleRepositoryProtocol {
    func getVehicles(
        query: String?,
        sortBy: FleetioSortOrder?,
        filterStatus: String?,
        startCursor: String?,
        perPage: Int
    ) async -> Result<FleetioPageResponse<VehicleModel>, APIError>
    
    func getVehicleDetails(id: String) async -> Result<VehicleModel, APIError>
    
    func getStatusFilters() async -> Result<FleetioPageResponse<StatusFilterModel>, APIError>
}

public class VehicleRepository: VehicleRepositoryProtocol, FleetioService {

    
    public var baseURL: String = "https://secure.fleetio.com/api"
    
    public func getVehicles(
        query: String? = nil,
        sortBy: FleetioSortOrder? = .desc,
        filterStatus: String? = nil,
        startCursor: String? = nil,
        perPage: Int = 50
    ) async -> Result<FleetioPageResponse<VehicleModel>, APIError> {

        var queryDict: [String : String] = [:]
        
        /// not sure how to do the OR query on the new API. Looks like it always defualts to AND behaviour 
        if let query, query.isEmpty == false {
            queryDict["name"] = query
//            queryDict["vin"] = query
        }
        
        var sortDict: [String : String] = [:]
        if let sortBy = sortBy {
            sortDict["name"] = sortBy.rawValue
        }

        do {
            let response = try await self.getPage(
                for: VehicleModel.self,
                "/vehicles",
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
    
    public func getVehicleDetails(id: String) async -> Result<VehicleModel, APIError> {
        do {
            let response = try await self.getDetails(
                for: VehicleModel.self,
                "/vehicles",
                id: id
            )
            return .success(response)
        } catch(let error as APIError) {
            return .failure(error)
        } catch {
            return .failure(.unknownError(error.localizedDescription))
        }
    }
    
    public func getStatusFilters() async -> Result<FleetioPageResponse<StatusFilterModel>, APIError> {        
        do {
            let response = try await self.getPage(
                for: StatusFilterModel.self,
                "/vehicle_statuses"
            )
            return .success(response)
        } catch(let error as APIError) {
            return .failure(error)
        } catch {
            return .failure(.unknownError(error.localizedDescription))
        }
    }
}
