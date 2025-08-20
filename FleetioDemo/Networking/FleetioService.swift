//
//  FleetioService.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import Foundation

public protocol FleetioService {
    var baseURL: String { get }
}

extension FleetioService {
    private var apiKey: String? {
        return Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    }
    
    private var accountToken: String? {
        return Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String
    }
    
    func getPage<T: Codable>(
        for: T.Type,
        _ forService: String,
        query: [String : String]? = nil,
        sortBy: [String : String]? = nil,
        filterStatus: String? = nil,
        startCursor: String? = nil,
        perPage: Int = 50
    ) async throws -> FleetioPageResponse<T> {
        guard let url = URL(string: baseURL + forService) else {
            throw APIError.invalidURL
        }
        
        guard let apiKey, let accountToken else {
            throw APIError.noAuth
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        /// Build queury parameter - on the newer api these are sent individually based on what we are searching.
        /// EX: - `filter[name][like]=truck&filter[vin][like]=truck`
        /// This makes it so that we cant combine the query into one search term like the older api using OR
        /// EX: - `q[name_or_vin_or_license_plate_cont]=truck`
        /// 
        /// only supporting like for now.
        var queryItems: [URLQueryItem] = []
        if let query, query.isEmpty == false {
            for (field, value) in query {
                queryItems.append(URLQueryItem(name: "filter[\(field)][like]", value: value))
            }
        }
        if let sortBy, sortBy.isEmpty == false {
            for (field, value) in sortBy {
                queryItems.append(URLQueryItem(name: "sort[\(field)]", value: value))
            }
        }
        
        /// Was not sure if this was possible or not. The older API allows for filtering on what looks like each field which is cool. New API seems to be limited to
        /// - `name, vin, licensePlate, externadId, Labels`
        ///
        /// Looking back I would have not spent so much time implementing this seeing that it wont work. However, i hope it still demonstrates the filtering ability I was trying to achieve.

//        if let filterStatus, filterStatus.isEmpty == false {
//            queryItems.append(URLQueryItem(name: "filter[vehicle_status_id_in][eq]", value: filterStatus))
//        }
        
        if let startCursor {
            queryItems.append(URLQueryItem(name: "start_cursor", value: startCursor))
        }
        queryItems.append(URLQueryItem(name: "per_page", value: String(perPage)))

        /// Because we are not using device storage to save our response between session, but the api is returning 304 with empty responses
        /// our intial load of data is broken if we dont query the API before closing the app.
        /// because this was not documented and I found it later while testing I've added this timestamp to ensure we dont recieve 304.
        /// But, if this was a larger project and we were using the API more than for a demo proper 304 handling should be added.
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        queryItems.append(URLQueryItem(name: "timestamp", value: timeStamp))

        components?.queryItems = queryItems
        
        var request = URLRequest(url: components!.url!)
        request.httpMethod = "GET"
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(accountToken, forHTTPHeaderField: "Account-Token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }
        
        /// just in case we somehow still get a 304, we should still count this as a success
        if httpResponse.statusCode == 304 {
            return FleetioPageResponse<T>(
                startCursor: startCursor,
                nextCursor: nil,
                perPage: perPage,
                estimatedRemainingCount: 0,
                records: [],
                noChanges: true
            )
        }

        /// if status code is between 401 - 500 we should expect a formated failure response. This response is pretty much set up for alert messages or notifications.
        /// for now we will just return the title value.
        if (200...299).contains(httpResponse.statusCode) == false {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let title = json["title"] as? String {
                throw APIError.fleetioError(title)
            }
                
            // we should handle the 400 error, as its a different format from the above.
            throw APIError.fleetioError("Invalid Request Format")
        }
            
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let pageModel = try decoder.decode(FleetioPageResponse<T>.self, from: data)
            return pageModel
        } catch {
            throw APIError.invalidData
        }
    }

    func getDetails<T: Codable>(
        for: T.Type,
        _ forService: String,
        id: String
    ) async throws -> T {
        guard let url = URL(string: baseURL + forService + "/\(id)") else {
            throw APIError.invalidURL
        }

        guard let apiKey, let accountToken else {
            throw APIError.noAuth
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        var queryItems: [URLQueryItem] = []
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        queryItems.append(URLQueryItem(name: "timestamp", value: timeStamp))
        components?.queryItems = queryItems
        
        var request = URLRequest(url: components!.url!)
        request.httpMethod = "GET"
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(accountToken, forHTTPHeaderField: "Account-Token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }

        if (200...299).contains(httpResponse.statusCode) == false {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let title = json["title"] as? String {
                throw APIError.fleetioError(title)
            }
                
            // we should handle the 400 error, as its a different format from the above.
            throw APIError.fleetioError("Invalid Request Format")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch {
            throw APIError.invalidData
        }
    }
}

// MARK: - APIError and PageResponseModel
public enum APIError: Error, LocalizedError {
    case invalidURL
    case noAuth
    case invalidData
    case unknownError(String)
    case fleetioError(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noAuth:
            return "Invalid Auth"
        case .invalidData:
            return "Invalid data"
        case .unknownError(let message):
            return message
        case .fleetioError(let message):
            return message
        }
    }
}

public struct FleetioPageResponse<T: Codable>: Codable {
    public let startCursor: String?
    public let nextCursor: String? 
    public let perPage: Int? 
    public let estimatedRemainingCount: Int?
    public let records: [T]
    
    public var noChanges: Bool? = false
}
