//
//  RideHistoryViewModel.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

import Foundation
import SwiftUI

class RideHistoryViewModel: ObservableObject {
    @Published var rides: [RideRecord] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let rideService: RideServiceProtocol

    init(rideService: RideServiceProtocol = RideService()) {
        self.rideService = rideService
    }

    func fetchRideHistory(customerID: String, driverID: String?) async {
        do {
            self.rides = try await rideService.fetchRideHistory(customerID: customerID, driverID: driverID)

            if rides.isEmpty {
                await MainActor.run {
                    self.errorMessage = "Nenhuma viagem encontrada."
                }
            }
        } catch let error as RideServiceError {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ocorreu um erro ao buscar o histórico. Tente novamente mais tarde."
            }
        }
    }
}
