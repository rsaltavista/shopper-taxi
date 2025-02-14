//
//  RideOption.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

struct RideOption: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let vehicle: String
    let review: RideReview
    let value: Double
}
