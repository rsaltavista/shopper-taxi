//
//  RideRequestView.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

import SwiftUI

struct RideRequestView: View {
    @StateObject var viewModel = RideRequestViewModel()
    @State private var navigateToOptions = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("ID do Usuário", text: $viewModel.customerID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Endereço de Origem", text: $viewModel.origin)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Endereço de Destino", text: $viewModel.destination)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            Button("Estimar Viagem") {
                Task {
                    await viewModel.requestRideEstimate()
                    
                    if let error = viewModel.errorMessage {
                        alertMessage = error
                        showAlert = true
                    } else if viewModel.rideEstimate != nil {
                        navigateToOptions = true
                    }
                }
            }
            .padding()
            .background(Color.blueShopper)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .cornerRadius(8)
            
            NavigationLink(
                destination: RideOptionsView(rideEstimate: viewModel.rideEstimate, customerID: viewModel.customerID),
                isActive: $navigateToOptions,
                label: { EmptyView() }
            )
        }
        .navigationTitle("Solicitar Viagem")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Erro"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
    }
}
