//
//  RideOptionsViewModel.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

import Foundation
import SwiftUI

class RideOptionsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var confirmationSuccess: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let rideService: RideServiceProtocol
    
    init(rideService: RideServiceProtocol = RideService()) {
        self.rideService = rideService
    }
    
    func getValidDrivers(for estimate: RideEstimateResponse) -> [RideOption] {
        let distanceInKm = estimate.distance / 1000
        return estimate.options.filter { option in
            switch option.id {
            case 1: return distanceInKm >= 1
            case 2: return distanceInKm >= 5
            case 3: return distanceInKm >= 10
            default: return false
            }
        }
    }
    
    func confirmRide(estimate: RideEstimateResponse, selectedOption: RideOption, customerID: String) async {
        guard !isLoading else { return }
        
        await MainActor.run { self.isLoading = true }
        
        do {
            try await rideService.confirmRide(estimate: estimate, selectedOption: selectedOption, customerID: customerID)
            await MainActor.run {
                self.confirmationSuccess = true
                self.errorMessage = nil
                self.isLoading = false
            }
        } catch let error as NetworkError {
            print("Erro capturado no RideOptionsViewModel: \(error)")
            
            await MainActor.run {
                self.confirmationSuccess = false
                
                switch error {
                case .serverError(let message):
                    print("Mensagem de erro do servidor: \(message)")
                    self.errorMessage = message
                case .invalidURL:
                    self.errorMessage = "Erro na URL da requisição."
                case .requestFailed(let statusCode):
                    self.errorMessage = "Erro de requisição: Código \(statusCode)."
                case .decodingFailed:
                    self.errorMessage = "Erro ao processar resposta do servidor."
                default:
                    self.errorMessage = "Erro desconhecido: \(error.localizedDescription)"
                }
                
                self.alertMessage = self.errorMessage ?? "Erro desconhecido."
                self.showAlert = true
                self.isLoading = false
            }
        }
        
        catch {
            await MainActor.run {
                self.confirmationSuccess = false
                self.errorMessage = "Erro ao confirmar viagem: \(error.localizedDescription)"
                self.showAlert = true
                self.isLoading = false
            }
        }
    }
}
