//
//  APIClient.swift
//  TalkToGPT
//
//  Created by Eray Diler on 21.03.2023.
//

import Foundation

struct APIClient: NetworkClient {
    let session: any NetworkSession

    init(session: any NetworkSession = URLSession.shared) {
        self.session = session
    }

    @discardableResult
    func make(_ request: any NetworkRequest) async throws -> Data {
        let response: Response<NoPayload> = try await make(request)
        return response.data
    }

    @discardableResult
    func make<T: Codable>(_ request: any NetworkRequest) async throws -> T {
        let response: Response<T> = try await make(request)
        return response.payload
    }

    @discardableResult
    func make<T: Codable>(_ request: any NetworkRequest) async throws -> Response<T> {
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

    func getBytes(for request: NetworkRequest) async throws -> URLSession.AsyncBytes {
        return try await session.bytes(for: request)
    }
}
