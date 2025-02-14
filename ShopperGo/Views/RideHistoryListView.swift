
//
//  RideHistoryListView.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//
import SwiftUI

struct RideHistoryListView: View {
    var rides: [RideRecord]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(rides) { ride in
                    RideHistoryCell(ride: ride)
                }
            }
            .padding(.top, 10)
        }
        .navigationTitle("Histórico de Viagens")
        .background(Color(.systemGroupedBackground))
    }
}
