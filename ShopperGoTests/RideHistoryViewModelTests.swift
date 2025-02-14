
//
//  RideHistoryViewModelTests.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 14/02/25.
//

import XCTest
@testable import ShopperGo

class RideHistoryViewModelTests: XCTestCase {
    var viewModel: RideHistoryViewModel!
    var mockRideService: MockRideService!

    override func setUp() {
        super.setUp()
        mockRideService = MockRideService()
        viewModel = RideHistoryViewModel(rideService: mockRideService)
    }

    override func tearDown() {
        viewModel = nil
        mockRideService = nil
        super.tearDown()
    }

    func testFetchRideHistory_Success() async {
        // Criando um histórico de viagens mockado
        let mockRide = RideRecord(
            id: 1,
            date: "2024-12-26T09:35:44",
            origin: "Rua A, 123",
            destination: "Rua B, 456",
            distance: 10.5,
            duration: "15:30",
            driver: RideDriver(id: 2, name: "James Bond"),
            value: 100.50
        )

        mockRideService.mockResponseData = [mockRide]

        await viewModel.fetchRideHistory(customerID: "CT01", driverID: nil)

        XCTAssertEqual(viewModel.rides.count, 1)
        XCTAssertEqual(viewModel.rides.first?.id, 1)
        XCTAssertEqual(viewModel.rides.first?.driver.name, "James Bond")
    }

    func testFetchRideHistory_Failure() async {
        // Simulando um erro no serviço
        mockRideService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)

        await viewModel.fetchRideHistory(customerID: "CT01", driverID: nil)

        XCTAssertTrue(viewModel.rides.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testFetchRideHistory_ReturnsData() async {
        // Simula uma resposta válida da API com RideRecord real
        let sampleRide = RideRecord(
            id: 1,
            date: "2024-12-26T09:35:44",
            origin: "Rua A, 123",
            destination: "Rua B, 456",
            distance: 10.5,
            duration: "15:30",
            driver: RideDriver(id: 2, name: "James Bond"),
            value: 100.50
        )

        mockRideService.mockResponseData = [sampleRide]

        // Executa a chamada assíncrona
        await viewModel.fetchRideHistory(customerID: "CT01", driverID: nil)

        // Verifica se os dados foram preenchidos corretamente
        XCTAssertEqual(viewModel.rides.count, 1)
        XCTAssertEqual(viewModel.rides[0].id, 1)
        XCTAssertEqual(viewModel.rides[0].driver.name, "James Bond")
    }

}
