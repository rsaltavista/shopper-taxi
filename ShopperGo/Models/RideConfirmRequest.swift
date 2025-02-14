//
//  RideConfirmRequest.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

struct RideConfirmRequest: Codable {
    let customer_id: String
    let origin: String
    let destination: String
    let distance: Double
    let duration: String
    let driver: RideDriver
    let value: Double
}
