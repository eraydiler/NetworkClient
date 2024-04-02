//
//  NetworkSession.swift
//  TalkToGPT
//
//  Created by Eray Diler on 20.04.2023.
//

import Foundation
import os

protocol NetworkSession {
    func data(from: URL) async throws -> Data
    func data(from request: NetworkRequest) async throws -> Data
    func bytes(for request: NetworkRequest) async throws -> URLSession.AsyncBytes
}

extension URLSession: NetworkSession {
    func data(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await self.data(from: url, delegate: nil)
            try verifyResponse(response)
            logResponse(url, response, data)
            return data
        } catch {
            logError(error)
            throw NetworkError.network(error)
        }
    }

    func data(from request: any NetworkRequest) async throws -> Data {
        do {
            let urlRequest = try generateUrlRequest(from: request)
            let (data, response) = try await self.data(for: urlRequest, delegate: nil)
            logResponse(urlRequest, response, data)
            try verifyResponse(response)
            return data
        } catch {
            logError(error)
            throw error
        }
    }

    func bytes(for request: NetworkRequest) async throws -> URLSession.AsyncBytes {
        do {
            let urlRequest = try generateUrlRequest(from: request)
            let (result, response) = try await self.bytes(for: urlRequest)
            logResponse(urlRequest, response, result)
            try verifyResponse(response)
            return result
        } catch {
            logError(error)
            throw error
        }
    }
}

extension NetworkSession {
    fileprivate func verifyResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        let validStatus = 200...299
        let code = httpResponse.statusCode
        if !validStatus.contains(code) {
            throw NetworkError.invalidStatus(NetworkError.HTTPStatusCode(rawValue: code))
        }
    }

    fileprivate func generateURL(from request: any NetworkRequest) -> URL? {
        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.host
        components.path = request.path
        return components.url
    }

    fileprivate func generateUrlRequest(from request: any NetworkRequest) throws -> URLRequest {
        guard let url = generateURL(from: request) else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        if let body = request.body {
            do {
                let encodedBody = try JSONEncoder.default.encode(body)
                urlRequest.httpBody = encodedBody
            } catch {
                throw NetworkError.invalidBody
            }
        }

        request.headers.forEach { element in
            urlRequest.setValue(element.value, forHTTPHeaderField: element.key.rawValue)
        }

        return urlRequest
    }
}

// Logging

fileprivate extension NetworkSession {
    func logResponse(_ items: Any...) {
        var itemsToLog = [Any]()

        for item in items {
            if let data = item as? Data {
                let responseBody = String(data: data, encoding: .utf8) ?? ""
                itemsToLog.append(responseBody)
            } else {
                itemsToLog.append(item)
            }
        }

        debugPrint(itemsToLog, separator: "\n")
    }

    func logError(_ error: Error) {
        let logger = Logger()
        logger.error("\(error.localizedDescription)")
    }
}
