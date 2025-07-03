// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol NetworkClient: Sendable {
    var session: any NetworkSession { get }

    func make(_ request: any NetworkRequest) async throws -> Data
    func make<T: Codable>(_ request: any NetworkRequest) async throws -> T
    func make<T: Codable>(_ request: any NetworkRequest) async throws -> Response<T>
    func getBytes(for request: any NetworkRequest) async throws -> URLSession.AsyncBytes
}

// To mark methods as optionals
public extension NetworkClient {
    @discardableResult
    func make(_ request: any NetworkRequest) async throws -> Data {
        fatalError("Must be implemented by concrete classes")
    }

    @discardableResult
    func make<T: Codable>(_ request: any NetworkRequest) async throws -> T {
        fatalError("Must be implemented by concrete classes")
    }

    @discardableResult
    func make<T: Codable>(_ request: any NetworkRequest) async throws -> Response<T> {
        fatalError("Must be implemented by concrete classes")
    }
    
    @discardableResult
    func getBytes(for request: any NetworkRequest) async throws -> URLSession.AsyncBytes {
        fatalError("Must be implemented by concrete classes")
    }
}
