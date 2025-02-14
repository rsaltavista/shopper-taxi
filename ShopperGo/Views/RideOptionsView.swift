//
//  RideOptionsView.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

import SwiftUI
import MapKit

struct RideOptionsView: View {
    var rideEstimate: RideEstimateResponse?
    var customerID: String
    @StateObject var viewModel = RideOptionsViewModel()
    @State private var navigateToHistory = false

    var body: some View {
        VStack {
            if let estimate = rideEstimate {
                RideOptionsMapView(
                    origin: CLLocationCoordinate2D(
                        latitude: estimate.origin.latitude,
                        longitude: estimate.origin.longitude
                    ),
                    destination: CLLocationCoordinate2D(
                        latitude: estimate.destination.latitude,
                        longitude: estimate.destination.longitude
                    )
                )
                .frame(height: 250)
                
                let validDrivers = viewModel.getValidDrivers(for: estimate)

                if validDrivers.isEmpty {
                    Text("Nenhum motorista disponível para essa distância.")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        ForEach(validDrivers) { option in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(getDriverImageName(option.name))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                    
                                    Text(option.name)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                
                                Text(option.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Image(getVehicleImageName(option.vehicle))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 50)
                                        .cornerRadius(10)
                                    
                                    Text("🚗 \(option.vehicle)")
                                        .font(.subheadline)
                                }
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("\(option.review.rating, specifier: "%.1f")")
                                }
                                
                                Text("💰 Valor: R$ \(String(format: "%.2f", option.value))")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                
                                Button(action: {
                                    Task {
                                        await viewModel.confirmRide(estimate: estimate, selectedOption: option, customerID: customerID)
                                        if viewModel.confirmationSuccess {
                                            navigateToHistory = true
                                        }
                                    }
                                }) {
                                    Text("Escolher")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.greenShopper)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .fontWeight(.bold)
                                }
                                .padding(.top, 8)
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                            .listRowBackground(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {}
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            } else {
                Text("Nenhuma estimativa disponível.")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            NavigationLink(
                destination: RideHistoryView(),
                isActive: $navigateToHistory,
                label: { EmptyView() }
            )
        }
        .navigationTitle("Opções de Viagem")
    }
    
    private func getDriverImageName(_ name: String) -> String {
        switch name.lowercased() {
        case "homer simpson": return "homersimpson"
        case "james bond": return "jamesbond"
        case "dominic toretto": return "dominictoretto"
        default: return "defaultdriver"
        }
    }

    private func getVehicleImageName(_ vehicle: String) -> String {
        switch vehicle.lowercased() {
        case "plymouth valiant 1973 rosa e enferrujado": return "plymouthvaliant1973"
        case "aston martin db5 clássico": return "astonmartindb5"
        case "dodge charger r/t 1970 modificado": return "dodgechargertoretto"
        default: return "defaultcar"
        }
    }
}

struct RideOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        RideOptionsView(rideEstimate: nil, customerID: "CT01")
    }
}
