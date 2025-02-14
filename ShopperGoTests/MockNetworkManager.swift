//
//  MockNetworkManager.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 14/02/25.
//

import Foundation
@testable import ShopperGo

class MockNetworkManager: NetworkManagerProtocol {
    var mockResponseData: Data?
    var mockError: Error?
    var mockResponse: URLResponse?

    func performRequest<T: Decodable>(endpoint: String, method: String, body: Data? = nil) async throws -> T {
        if let error = mockError {
            throw error
        }
        guard let data = mockResponseData else {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Dados ausentes"])
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    func performRawRequest(endpoint: String, method: String, body: Data?) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockResponseData, let response = mockResponse else {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta ausente"])
        }
        return (data, response)
    }

    func performVoidRequest(endpoint: String, method: String, body: Data?) async throws {
        if let error = mockError {
            throw error
        }
        // Simulação de sucesso sem retorno
    }
}
