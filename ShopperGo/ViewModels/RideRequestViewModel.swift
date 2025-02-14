//
//  RideRequestViewModel.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

import Foundation
import SwiftUI

class RideRequestViewModel: ObservableObject {
    @Published var customerID: String = ""
    @Published var origin: String = ""
    @Published var destination: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var rideEstimate: RideEstimateResponse?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func requestRideEstimate() async {
        guard !isLoading else { return }

        await MainActor.run {
            self.errorMessage = nil
            self.rideEstimate = nil
        }

        guard !customerID.isEmpty, !origin.isEmpty, !destination.isEmpty else {
            await MainActor.run {
                self.errorMessage = "Preencha todos os campos."
                self.showAlert = true
            }
            return
        }

        let requestData = RideEstimateRequest(customer_id: customerID, origin: origin, destination: destination)
        guard let body = try? JSONEncoder().encode(requestData) else {
            await MainActor.run {
                self.errorMessage = "Erro ao preparar dados."
                self.showAlert = true
            }
            return
        }

        await MainActor.run { self.isLoading = true }
        do {
            let response: RideEstimateResponse = try await networkManager.performRequest(endpoint: "/ride/estimate", method: "POST", body: body)
            await MainActor.run {
                self.rideEstimate = response
                self.isLoading = false
            }
        } catch let error as NetworkError {
            await MainActor.run {
                print("Erro capturado no RideRequestViewModel: \(error)")
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
        } catch {
            await MainActor.run {
                self.errorMessage = "Erro ao confirmar viagem: \(error.localizedDescription)"
                self.alertMessage = self.errorMessage ?? "Erro desconhecido."
                self.showAlert = true
                self.isLoading = false
            }
        }
    }
}
