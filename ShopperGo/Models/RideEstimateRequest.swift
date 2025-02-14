//
//  RideEstimateRequest.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//
struct RideEstimateRequest: Codable {
    let customer_id: String
    let origin: String
    let destination: String
}
