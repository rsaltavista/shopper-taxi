//
//  RideEstimateResponse.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

struct RideEstimateResponse: Codable {
    let origin: Coordinate
    let destination: Coordinate
    let distance: Double
    let duration: Int
    let options: [RideOption]
}
