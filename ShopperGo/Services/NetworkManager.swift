//
//  NetworkManager.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

import SwiftUI
import Foundation

protocol NetworkManagerProtocol {
    func performRequest<T: Decodable>(endpoint: String, method: String, body: Data?) async throws -> T
    func performVoidRequest(endpoint: String, method: String, body: Data?) async throws
    func performRawRequest(endpoint: String, method: String, body: Data?) async throws -> (Data, URLResponse)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let baseURL = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws"
    
    func performRequest<T: Decodable>(endpoint: String, method: String, body: Data? = nil) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Código HTTP recebido: \(httpResponse.statusCode)")
            print("📥 JSON recebido da API:")
            print(String(data: data, encoding: .utf8) ?? "Erro ao converter dados para string")
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError("Resposta inválida do servidor.")
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
               let errorMessage = errorResponse["error_description"] {
                print("Mensagem de erro extraída corretamente da API: \(errorMessage)")
                throw NetworkError.serverError(message: errorMessage)
            } else {
                throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
            }
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
    
    func performRawRequest(endpoint: String, method: String, body: Data? = nil) async throws -> (Data, URLResponse) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await URLSession.shared.data(for: request)
    }

    func performVoidRequest(endpoint: String, method: String, body: Data? = nil) async throws {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
    }
}
