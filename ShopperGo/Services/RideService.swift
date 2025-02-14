//
//  RideService.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 14/02/25.
//
import Foundation

protocol RideServiceProtocol {
    func fetchRideHistory(customerID: String, driverID: String?) async throws -> [RideRecord]
    func confirmRide(estimate: RideEstimateResponse, selectedOption: RideOption, customerID: String) async throws
}

class RideService: RideServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func fetchRideHistory(customerID: String, driverID: String?) async throws -> [RideRecord] {
        let endpoint = "/ride/\(customerID)"
        
        do {
            let response: RideHistoryResponse = try await networkManager.performRequest(endpoint: endpoint, method: "GET", body: nil)

            if let driverID = driverID, !driverID.isEmpty {
                let validDriverIDs = Set(response.rides.map { String($0.driver.id) })
                if !validDriverIDs.contains(driverID) {
                    throw RideServiceError.invalidDriver
                }
            }

            return response.rides
        } catch {
            if let urlError = error as? URLError, urlError.code == .badServerResponse {
                throw RideServiceError.invalidUserID
            }
            throw error
        }
    }

    func confirmRide(estimate: RideEstimateResponse, selectedOption: RideOption, customerID: String) async throws {
        let requestData = RideConfirmRequest(
            customer_id: customerID,
            origin: estimate.origin.latitude.description,
            destination: estimate.destination.latitude.description,
            distance: estimate.distance,
            duration: String(estimate.duration),
            driver: RideDriver(id: selectedOption.id, name: selectedOption.name),
            value: selectedOption.value
        )

        let body = try JSONEncoder().encode(requestData)

        do {
            _ = try await networkManager.performVoidRequest(endpoint: "/ride/confirm", method: "PATCH", body: body)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknownError(error.localizedDescription)
        }
    }
}
