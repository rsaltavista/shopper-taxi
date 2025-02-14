//
//  RideOptionsViewModelTests.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 14/02/25.
//

import XCTest
@testable import ShopperGo

import XCTest
@testable import ShopperGo

class RideOptionsViewModelTests: XCTestCase {
    var viewModel: RideOptionsViewModel!
    var mockRideService: MockRideService!

    override func setUp() {
        super.setUp()
        mockRideService = MockRideService()
        viewModel = RideOptionsViewModel(rideService: mockRideService)
    }

    override func tearDown() {
        viewModel = nil
        mockRideService = nil
        super.tearDown()
    }

    func testConfirmRide_Success() async {
        mockRideService.mockError = nil // Simula uma resposta bem-sucedida

        let estimate = RideEstimateResponse(
            origin: Coordinate(latitude: 0.0, longitude: 0.0),
            destination: Coordinate(latitude: 1.0, longitude: 1.0),
            distance: 10_000, // 10km
            duration: 16,
            options: []
        )

        let option = RideOption(id: 1, name: "Homer Simpson", description: "", vehicle: "", review: RideReview(rating: 5.0, comment: ""), value: 100.0)

        await viewModel.confirmRide(estimate: estimate, selectedOption: option, customerID: "CT01")

        XCTAssertTrue(viewModel.confirmationSuccess)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testConfirmRide_Failure() async {
        mockRideService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil) // Simula erro da API

        let estimate = RideEstimateResponse(
            origin: Coordinate(latitude: 0.0, longitude: 0.0),
            destination: Coordinate(latitude: 1.0, longitude: 1.0),
            distance: 10_000, // 10km
            duration: 16,
            options: []
        )

        let option = RideOption(id: 1, name: "Homer Simpson", description: "", vehicle: "", review: RideReview(rating: 5.0, comment: ""), value: 100.0)

        await viewModel.confirmRide(estimate: estimate, selectedOption: option, customerID: "CT01")

        XCTAssertFalse(viewModel.confirmationSuccess)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}

