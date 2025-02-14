//
//  RideServiceError.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 14/02/25.
//
import Foundation

enum RideServiceError: LocalizedError {
    case invalidDriver
    case invalidUserID

    var errorDescription: String? {
        switch self {
        case .invalidDriver:
            return "Nenhuma viagem encontrada para o motorista informado."
        case .invalidUserID:
            return "Usuário não encontrado. Verifique o ID e tente novamente."
        }
    }
}
