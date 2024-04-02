// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol NetworkClient {
    var session: any NetworkSession { get }

    func make(_ request: NetworkRequest) async throws -> Data
    func make<T: Codable>(_ request: NetworkRequest) async throws -> T
    func make<T: Codable>(_ request: NetworkRequest) async throws -> Response<T>
    func getBytes(for request: NetworkRequest) async throws -> URLSession.AsyncBytes
}
