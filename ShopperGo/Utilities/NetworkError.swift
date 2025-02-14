//
//  NetworkError.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 14/02/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    case serverError(message: String)
    case unknownError(String)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "A URL da requisição é inválida."
        case .requestFailed(let statusCode):
            return "Erro na requisição. Código HTTP: \(statusCode)."
        case .decodingFailed:
            return "Erro ao processar a resposta do servidor."
        case .serverError(let message):
            return message
        case .unknownError(let message):
            return "Erro desconhecido: \(message)"
        }
    }
}
