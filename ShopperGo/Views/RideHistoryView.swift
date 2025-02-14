//
//  RideHistoryView.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//
import SwiftUI

struct RideHistoryView: View {
    @StateObject var viewModel = RideHistoryViewModel()
    @State private var customerID: String = ""
    @State private var driverID: String = ""
    @State private var navigateToHistory = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("ID do Usuário", text: $customerID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("ID do Motorista (opcional)", text: $driverID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Buscar Histórico") {
                Task {
                    viewModel.errorMessage = nil
                    await viewModel.fetchRideHistory(customerID: customerID, driverID: driverID.isEmpty ? nil : driverID)

                    if let error = viewModel.errorMessage {
                        alertMessage = error
                        showAlert = true
                    } else if !viewModel.rides.isEmpty {
                        navigateToHistory = true
                    }
                }
            }
            .padding()
            .background(Color.greenShopper)
            .foregroundColor(.white)
            .cornerRadius(8)

            if viewModel.isLoading {
                ProgressView()
            }

            NavigationLink(
                destination: RideHistoryListView(rides: viewModel.rides),
                isActive: $navigateToHistory,
                label: { EmptyView() }
            )
        }
        .navigationTitle("Histórico de Viagens")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Erro"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct RideHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RideHistoryView()
    }
}
