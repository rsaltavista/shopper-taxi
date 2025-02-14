import XCTest
@testable import ShopperGo

class RideServiceTests: XCTestCase {
    var rideService: RideService!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        rideService = RideService(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        rideService = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testFetchRideHistory_Success() async throws {
        // Simula uma resposta válida da API
        let jsonData = """
        {
            "rides": [
                {
                    "id": 1,
                    "date": "2024-12-26T09:35:44",
                    "origin": "Rua A, 123",
                    "destination": "Rua B, 456",
                    "distance": 10.5,
                    "duration": "15:30",
                    "driver": { "id": 2, "name": "James Bond" },
                    "value": 100.50
                }
            ]
        }
        """.data(using: .utf8)

        mockNetworkManager.mockResponseData = jsonData

        let rides = try await rideService.fetchRideHistory(customerID: "CT01", driverID: nil)

        XCTAssertEqual(rides.count, 1)
        XCTAssertEqual(rides[0].id, 1)
        XCTAssertEqual(rides[0].driver.name, "James Bond")
    }

    func testFetchRideHistory_Failure() async {
        // Simula um erro de rede
        mockNetworkManager.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)

        do {
            _ = try await rideService.fetchRideHistory(customerID: "CT01", driverID: nil)
            XCTFail("A chamada deveria falhar, mas não falhou.")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testConfirmRide_Success() async throws {
        // Simula uma resposta vazia para sucesso
        mockNetworkManager.mockResponseData = "{}".data(using: .utf8)

        let estimate = RideEstimateResponse(
            origin: Coordinate(latitude: 0.0, longitude: 0.0),
            destination: Coordinate(latitude: 1.0, longitude: 1.0),
            distance: 10.0,
            duration: 16,
            options: []
        )

        let option = RideOption(
            id: 1,
            name: "Homer Simpson",
            description: "",
            vehicle: "",
            review: RideReview(rating: 0.0, comment: ""),
            value: 100.0
        )

        try await rideService.confirmRide(estimate: estimate, selectedOption: option, customerID: "CT01")

        XCTAssertTrue(true) // Apenas garantindo que não houve erro
    }

    func testConfirmRide_Failure() async {
        // Simula um erro ao confirmar a viagem
        mockNetworkManager.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)

        let estimate = RideEstimateResponse(
            origin: Coordinate(latitude: 0.0, longitude: 0.0),
            destination: Coordinate(latitude: 1.0, longitude: 1.0),
            distance: 10.0,
            duration: 16,
            options: []
        )

        let option = RideOption(
            id: 1,
            name: "Homer Simpson",
            description: "",
            vehicle: "",
            review: RideReview(rating: 0.0, comment: ""),
            value: 100.0
        )

        do {
            try await rideService.confirmRide(estimate: estimate, selectedOption: option, customerID: "CT01")
            XCTFail("A confirmação deveria falhar, mas não falhou.")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
