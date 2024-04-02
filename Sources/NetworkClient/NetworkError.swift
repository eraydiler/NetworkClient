//
//  NetworkError.swift
//  TalkToGPT
//
//  Created by Eray Diler on 20.04.2023.
//

import Foundation

enum NetworkError: Error {
    case unknown
    case invalidURL
    case invalidBody
    case decoding(Error)
    case invalidStatus(HTTPStatusCode?)
    case invalid(URLResponse)
    case networkError
    case network(Error)
}

extension NetworkError {
    enum HTTPStatusCode: Int, LocalizedError {
        case ok = 200
        case created = 201
        case badRequest = 400
        case unauthorized = 401
        case notFound = 404
        case internalServerError = 500

        var errorDescription: String? {
            switch self {
            case .ok, .created:
                return "Request was successful"
            case .badRequest:
                return "Bad request"
            case .unauthorized:
                return "Unauthorized access"
            case .notFound:
                return "Resource not found"
            case .internalServerError:
                return "Internal server error"
            }
        }
    }
}
