//
//  RideInfoRow.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 14/02/25.
//

import SwiftUI

struct RideInfoRow: View {
    var icon: String
    var text: String
    var color: Color = .black
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}
