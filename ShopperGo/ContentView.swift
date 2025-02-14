//
//  ContentView.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("logo3shoppertaxi")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding(.top, 40)
                
                HStack(spacing: 20) {
                    NavigationLink(destination: RideRequestView()) {
                        Text("Solicitar Viagem")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .padding()
                            .background(Color.blueShopper)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: RideHistoryView()) {
                        Text("Histórico de Viagens")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .padding()
                            .background(Color.greenShopper)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 100)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
