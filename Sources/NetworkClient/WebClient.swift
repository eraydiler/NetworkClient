//
//  APIClient.swift
//  TalkToGPT
//
//  Created by Eray Diler on 21.03.2023.
//

import Foundation

open class WebClient: NetworkClient {
    public let session: any NetworkSession

    public init(session: any NetworkSession = URLSession.shared) {
        self.session = session
    }

    @discardableResult
    public func make(_ request: any NetworkRequest) async throws -> Data {
        let response: Response<NoPayload> = try await make(request)
        return response.data
    }

    @discardableResult
    public func make<T: Codable>(_ request: any NetworkRequest) async throws -> T {
        let response: Response<T> = try await make(request)
        return response.payload
    }

    @discardableResult
    public func make<T: Codable>(_ request: any NetworkRequest) async throws -> Response<T> {
        let data: Data

        do {
            data = try await session.data(from: request)
        } catch {
            throw NetworkError.network(error)
        }

        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return Response(payload: result, data: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

    public func getBytes(for request: NetworkRequest) async throws -> URLSession.AsyncBytes {
        return try await session.bytes(for: request)
    }
}
