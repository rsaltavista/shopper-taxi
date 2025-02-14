import Foundation
@testable import ShopperGo

class MockRideService: RideServiceProtocol {
    var mockError: Error?
    var mockResponseData: [RideRecord] = [] // 🔹 Adicionando suporte para dados simulados

    func fetchRideHistory(customerID: String, driverID: String?) async throws -> [RideRecord] {
        if let error = mockError {
            throw error
        }
        return mockResponseData // 🔹 Retorna os dados mockados
    }

    func confirmRide(estimate: RideEstimateResponse, selectedOption: RideOption, customerID: String) async throws {
        if let error = mockError {
            throw error
        }
    }
}

